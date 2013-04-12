class User < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :street_orig, :street_dest, :path

  validates :name,:name,:phone,:street_orig,:street_dest, :presence => true

  validates :email,:phone, :uniqueness => true
end
