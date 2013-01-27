require 'nokogiri'
require 'open-uri'

desc "This task is called by the Heroku scheduler add-on"

task :get_tweets => :environment do
  
	puts "Getting tweets..." 
	
	tweetsxml = Nokogiri::XML(open('https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=1310traffic'))
	#tweetsxml = Nokogiri::XML(open('https://api.twitter.com/1/statuses/user_timeline.xml?screen_name=benjlcox'))
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

	cleanstatus.each do |x|
		x.gsub!(/^.{9}/, "")
		x.gsub!(/\s[#].+$/, "")
		x[0] = x.first.capitalize[0]
	end

	cleaninfo = Hash[cleanid.zip(cleanstatus)]

	cleaninfo.each do |k,v|
	#	if Accident.exists?(:tid => k) == false
	#		Accident.create(:tid => "#{k}", :details => "#{v}", :time => "Do this next")
	#	end
	puts "Key = #{k} and Value = #{v}"
	end
	
	puts "Done."

end
