require 'oauth'
require 'json'
require 'nexmo'

desc "This gets all tweets, cleans them, and adds them to Accident - to be called by Heroku Scheduler"

task :get_tweets => :environment do
  
	#----------Twitter Oauth Stuff ----------------
	consumer_key = OAuth::Consumer.new(
	    "QTwARV2bD20hkW8rRg9KOw",
	    "f9c6hbdpg5qoCiEY5Y9LZPyDQXGHVBKAejWBMM")
	access_token = OAuth::Token.new(
	    "18572865-Ih12zZXKQI5T6kotHXA66VpD0cilR4IVfffk8tefe",
	    "m7udyW1Qz70vrQvyZHShVk7bwdszL3kzDL7BdI4IkTo")

	address = URI("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=1310traffic")

	#--------- Connecting to Twitter ---------------
	http = Net::HTTP.new address.host, address.port
	http.use_ssl = true #SSL required by Twitter
	http.verify_mode = OpenSSL::SSL::VERIFY_PEER

	request = Net::HTTP::Get.new address.request_uri
	request.oauth! http, consumer_key, access_token

	#--------- Making request -----------------
	http.start
	response = http.request request
	feed =nil
	feed = JSON.parse(response.body)

	#-------- Getting Tweets and TIDs -------------
	tid = []
	text = []
	feed.each do |tweet|
		tid.push(tweet['id'])
		text.push(tweet['text'])
	end

	tweets = Hash[tid.zip(text)] #Combine tweets and tids into a single hash (Tid => Tweet)

	#-------- Cleaning up the Tweets --------------
	tweets.delete_if{|k,v| !v.match(/^Ottawa -/)} #Removes non-Ottawa tweets
	tweets.each do |k,v| 
		v.gsub!(/^.{9}/, "") #Removes where it says "Ottawa - "
		v.gsub!(/\s[#].+$/, "") #Removes hashtags
		v[0] = v[0].capitalize #Capitalizes first letter of the sentence
	end

	#-------- Save tweets to the DB -------------
	tweets.each do |k,v|
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
		nexmo.send_message!({:to => "1#{phone}", :from => "16136272519", :text => "#{details}", :sleep => 2})
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
		accident.sms_sent = true
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
