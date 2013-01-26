desc "This task is called by the Heroku scheduler add-on"
task :get_tweets => :environment do
  puts "Getting tweets..."
  Accident.create(:tid => "123", :details => "This is a test tweet", :time => "May 12")
  puts "Done."
end
