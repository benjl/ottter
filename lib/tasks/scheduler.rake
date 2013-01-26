require 'nokogiri'
require 'open-uri'

desc "This task is called by the Heroku scheduler add-on"

task :get_tweets => :environment do
  
	puts "Getting tweets..." 
	
	tweetsxml = Nokogiri::XML(open('https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=1310traffic'))
	rawstatus = tweetsxml.xpath("//status//text")
	rawid = tweetsxml.xpath("//status/id")
	cleanstatus = []
	cleanid = []

	rawstatus.each do |x|
		cleanstatus.push(x.text)
	end

	rawid.each do |x|
		cleanid.push(x.text)
	end

	cleaninfo = Hash[cleanid.zip(cleanstatus)]

	cleaninfo.each do |k,v|
		Accident.create(:tid => "#{k}", :details => "#{v}", :time => "Do this next")
	end
	
	puts "Done."

end
