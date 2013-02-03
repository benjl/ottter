class Accident < ActiveRecord::Base
  attr_accessible :details, :tid, :time, :sms_sent
end
