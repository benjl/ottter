class User < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :street_orig, :street_dest, :path, :sched, :sched_mor_start, :sched_mor_end, :sched_eve_start, :sched_eve_end, :sens

  validates :name,:name,:phone,:street_orig,:street_dest, :presence => true

  validates :email,:phone, :uniqueness => true
end
