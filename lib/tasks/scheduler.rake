require 'nokogiri'
require 'open-uri'
require 'nexmo'

desc "This gets all tweets, cleans them, and adds them to Accident - to be called by Heroku Scheduler"

task :get_tweets => :environment do
  
	def make_proper_array (nokoname, newname) #Nokogiri compiles everything all messed up - this just makes it a clean array
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

	cleaninfo = Hash[cleanid.zip(cleanstatus)] #Combines the status (description) and ID (the TID) arrays into a hash

	cleaninfo.delete_if{|k,v| !v.match(/^Ottawa -/)} #Removes non-Ottawa tweets (nobody cares about Cornwall)

	cleaninfo.each do |k,v| #Removing a bunch of unnecessary tweet related stuff
		v.gsub!(/^.{9}/, "") 
		v.gsub!(/\s[#].+$/, "")
		v[0] = v.first.capitalize[0]
	end

	cleaninfo.each do |k,v|
		if Accident.exists?(:tid => k) == false #Make sure the tweet isn't already saved to the DB by checking if TID is already there
			Accident.create(:tid => "#{k}", :details => "#{v}", :time => "#{Time.now.to_i}") #Saving tweet to db, adding unix time
		end
	end
end

desc "Search Accidents for streets in Users and alert the users via SMS"

task :alert_users => :environment do
	
	#Nexmo stuff

	def send_sms (phone, details)
		nexmo = Nexmo::Client.new('f45ec1ce','460dfad4')
		nexmo.delay.send_message!({:to => "1#{phone}", :from => "16136272519", :text => "#{details}", :sleep => 2})
	end

	#Method for determining if messages should be sent

	def can_send(user)
		time = Time.now.strftime("%k").to_i #Converts current time to single integer for the hour

		if user.sched == true #Logic for users with a schedule. If user.sched is f then returnes true. 
			if time <= 11
				if user.sched_mor_start <= time && user.sched_mor_end >= time
					return true
				else
					false
				end
			elsif time >= 12
				if user.sched_eve_start <= time - 12 && user.sched_eve_end >= time - 12 #Subtracts 12 from time to fix 12hr and 24hr differnece
					return true
				else
					false
				end
			else
				return false
				console.log("INVALID TIME, USER => #{user.id}")
			end
		else
			return true
		end
	end

	#Method for sending messages

	def accdnt_msgs(user,accidents)
		user_streets = user.path.split(",").map(&:to_s) #Loads the User's streets from the db, removes commas and makes them an array
		
		if user_streets.include?("ON-417") #Fixes inconsistent naming of the 417 and 416 in tweets
			user_streets << "Queensway"
			user_streets << "Hwy 417"
			user_streets << "Hwy-417"
		elsif user_streets.include?("ON-416")
			user_streets << "Hwy 416"
			user_streets << "Hwy-416"
		end

		accidents.each do |accident| #Iterates over the accidents
			sauce = accident.details
			current_accident = Accident.find(accident.id) 
			if current_accident.sms_sent == false #Finds accidents that haven't been sent
				user_streets.each do |street| #Iterates over users		
					if sauce.include?(street) #Finds if user cares about that accident
						send_sms(user.phone,accident.details) #Sends SMS to user
						puts "Sending alert to #{user.phone}"
					end
				end
			end
		end
	end

	#Actual rake code

	accidents = Accident.find(:all, :conditions => {:sms_sent => false})
	users = User.find(:all)

	users.each do |user| #The sauce
		if can_send(user)
			accdnt_msgs(user,accidents)
		end
	end	
	
	accidents.each do |accident| #Now the alerting is done, set all sms_sent statuses to true
		accident.sms_sent = "true"
		accident.save
	end
end

task :send_sens_alert => :environment do

	#The season ended before I completed this feature, so it's TBD.

end

task :reset_sms => :environment do #Should probably delete this, used for early testing. Would actually cost a few dollars in SMS if ran
	accidents = Accident.find(:all)

	accidents.each do |accident|
		accident.sms_sent = "false"
		accident.save
	end
end
