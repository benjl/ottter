require 'nokogiri'
require 'open-uri'

desc "This gets all tweets, cleans them, and adds them to Accident - to be called by Heroku Scheduler"

task :get_tweets => :environment do
  
	def make_proper_array (nokoname, newname)
		nokoname.each do |x|
			newname.push(x.text)
		end
	end

	puts "Getting tweets..." 
	
	tweetsxml = Nokogiri::XML(open('https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=1310traffic'))
	#tweetsxml = Nokogiri::XML(open('https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=benjlcox'))
	
	rawstatus = tweetsxml.xpath("//status//text")
	rawid = tweetsxml.xpath("//status/id")
	
	cleanstatus = []
	cleanid = []
	counter = 0

	puts "Converting tweets..."

	make_proper_array(rawstatus, cleanstatus)
	make_proper_array(rawid, cleanid)

	puts "Cleaning tweets..."

	cleanstatus.each do |x|
		x.gsub!(/^.{9}/, "")
		x.gsub!(/\s[#].+$/, "")
		x[0] = x.first.capitalize[0]
	end

	puts "Merging tweets with ids..."

	cleaninfo = Hash[cleanid.zip(cleanstatus)]

	puts "Adding tweets to db..."

	cleaninfo.each do |k,v|
		if Accident.exists?(:tid => k) == false
			Accident.create(:tid => "#{k}", :details => "#{v}", :time => "Do this next")
		counter += 1
		end
		#puts "Key = #{k} and Value = #{v}"
		puts "#{v}"
	end
	
	puts "Done. Records added: #{counter}"

end
