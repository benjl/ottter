class User < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :street_orig, :street_dest, :path

  #validates :streets, :presence => true 

end
