require 'nokogiri'
require 'open-uri'
require 'nexmo'

desc "This gets all tweets, cleans them, and adds them to Accident - to be called by Heroku Scheduler"

task :get_tweets => :environment do
  
	def make_proper_array (nokoname, newname)
		nokoname.each do |x|
			newname.push(x.text)
		end
	end

	tweetsxml = Nokogiri::XML(open('https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=1310traffic'))
	#tweetsxml = Nokogiri::XML(open('https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=benjlcox'))
	
	rawstatus = tweetsxml.xpath("//status//text")
	rawid = tweetsxml.xpath("//status/id")
	
	cleanstatus = []
	cleanid = []

	make_proper_array(rawstatus, cleanstatus)
	make_proper_array(rawid, cleanid)

	cleaninfo = Hash[cleanid.zip(cleanstatus)]

	cleaninfo.delete_if{|k,v| !v.match(/^Ottawa -/)}

	cleaninfo.each do |k,v|
		v.gsub!(/^.{9}/, "")
		v.gsub!(/\s[#].+$/, "")
		v[0] = v.first.capitalize[0]
	end

	cleaninfo.each do |k,v|
		if Accident.exists?(:tid => k) == false
			Accident.create(:tid => "#{k}", :details => "#{v}", :time => "#{Time.now.to_i}")
		end
	end
end

desc "Search Accidents for streets in Users and alert the users via SMS"

task :alert_users => :environment do
	
	def send_sms (phone, details)
		nexmo = Nexmo::Client.new('f45ec1ce','460dfad4')
		puts "Sending => #{details} To => #{phone}"
		nexmo.delay.send_message!({:to => "1#{phone}", :from => '16136270717', :text => "#{details}", :sleep => 2})
	end

	def can_send(user)
		time = Time.now.strftime("%k").to_i

		if user.sched #this is horrible, horribly broken. It doesn't even text people that chose not to schedule! Needs to be made a method. 
			if time <= 11
				if user.sched_mor_start <= time && user.sched_mor_end >= time
					return true
				end
			elsif time >= 12
				if user.sched_eve_start <= time && user.sched_eve_end >= time
					return true
				end
			else
				return false
				console.log("INVALID TIME, USER => #{user.id}")
			end
		else
			return false
		end
	end

	def accdnt_msgs(user,accidents)
		user_streets = user.path.split(",").map(&:to_s) #Loads the User's streets from the db, removes commas and makes them an array
		
		if user_streets.include?("ON-417")
			user_streets << "Queensway"
			user_streets << "Hwy 417"
			user_streets << "Hwy-417"
		end

		accidents.each do |accident|
			sauce = accident.details
			current_accident = Accident.find(accident.id) 
			if current_accident.sms_sent == false
				user_streets.each do |street|		
					if sauce.include?(street)
						send_sms(user.phone,accident.details)
					end
				end
			end
		end
	end

	accidents = Accident.find(:all, :conditions => {:sms_sent => false})
	users = User.find(:all)

	users.each do |user|
		if user.sched
			if can_send(user)
				accdnt_msgs(user,accidents)
			end
		else
			accdnt_msgs(user,accidents)
		end
	end	
	
	accidents.each do |accident|
		accident.sms_sent = "true"
		accident.save
	end
end

task :send_sens_alert => :environment do
	def send_sms (phone, details)
		nexmo = Nexmo::Client.new('f45ec1ce','460dfad4')
		puts "Sending => #{details} To => #{phone}"
		nexmo.delay.send_message!({:to => "#{phone}", :from => '16136270717', :text => "#{details}", :sleep => 2})
	end

	users.each do |user|
		if user.sens
			send_sms(user.phone,"Heads up on the drive home tonight, there's a Sens home game!")
		end
	end

end

task :reset_sms => :environment do
	accidents = Accident.find(:all)

	accidents.each do |accident|
		accident.sms_sent = "false"
		accident.save
	end
end
