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
	counter = 0

	make_proper_array(rawstatus, cleanstatus)
	make_proper_array(rawid, cleanid)

	cleanstatus.each do |x|
		x.gsub!(/^.{9}/, "")
		x.gsub!(/\s[#].+$/, "")
		x[0] = x.first.capitalize[0]
	end

	cleaninfo = Hash[cleanid.zip(cleanstatus)]

	cleaninfo.each do |k,v|
		if Accident.exists?(:tid => k) == false
			Accident.create(:tid => "#{k}", :details => "#{v}", :time => "Do this next")
		counter += 1
		end
	end
end

desc "Search Accidents for streets in Users and alert the users via SMS"

task :alert_users => :environment do
	
	def send_sms (phone, details)
		nexmo = Nexmo::Client.new('f45ec1ce','460dfad4')
		puts "Sending => #{details} To => #{phone}"
		nexmo.delay.send_message!({:to => "#{phone}", :from => '16136270717', :text => "#{details}"}) #should be using delayed job, should also be a method
	end


	accidents = Accident.find(:all, :conditions => { :sms_sent => false})
	users = User.find(:all)

	users.each do |user|
		
		user_streets = user.streets.split(",").map(&:to_s) #Loads the User's streets form the db, removes commas and makes them an array
		
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
	
	accidents.each do |accident|
		accident.sms_sent = "true"
		accident.save
	end
end

task :reset_sms => :environment do
	accidents = Accident.find(:all)

	accidents.each do |accident|
		accident.sms_sent = "false"
		accident.save
	end
end
