class SessionsController < ApplicationController
	
	before_filter :authenticate_user, :only => [:home, :profile, :settings]
	before_filter :save_login_state, :only => [:login, :login_attempt]

	def login
		#Login Form
	end

	def login_attempt
		authorized_user = User.authenticate(params[:phone],params[:login_password])
		if authorized_user
			session[:user_id] = authorized_user.id
			flash[:notice] = "Welcome. You have logged in with the # #{authorized_user.phone}"
			redirect_to(:action => 'home')
		else
			flash[:notice] = "Invalid Phone # or Password"
			flash[:color]= "invalid"
			render "login"	
		end
	end

	def logout
		session[:user_id] = nil
		redirect_to :action => 'login'
	end

	def home
		@user = User.find(session[:user_id])
	end

	def settings
		@user = User.find(session[:user_id])
	end

	def delete

	end
end
