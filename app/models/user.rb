class User < ActiveRecord::Base
  attr_accessor :password
  PHONE_REGEX = /^[1][0-9]{10}$/
  attr_accessible :password, :password_confirmation, :phone, :street_orig, :street_dest, :path, :sched, :sched_mor_start, :sched_mor_end, :sched_eve_start, :sched_eve_end, :sens

  validates :phone, :presence => true, :uniqueness => true, :format => PHONE_REGEX

  validates :street_orig, :presence => true, :on => :edit
  validates :street_dest, :presence => true, :on => :edit

  validates :password, :confirmation => true #password_confirmation attr
  validates_length_of :password, :in => 6..20, :on => :create


  before_save :encrypt_password
  after_save :clear_password

	def match_password(login_password="")
		encrypted_password === BCrypt::Engine.hash_secret(login_password, salt)
	end

	def self.authenticate(phone="", login_password="")
		if  PHONE_REGEX.match(phone)    
			user = User.find_by_phone(phone)
		else
			return false
		end

		if user && user.match_password(login_password)
			return user
		else
			return false
		end
	end   

	def encrypt_password
		 if password.present?
			self.salt = BCrypt::Engine.generate_salt
			self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
		end
	end

	def clear_password
		self.password = nil
	end

end
