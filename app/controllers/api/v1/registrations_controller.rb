class Api::V1::RegistrationsController < Api::V1::ApplicationController
	# Need to skip from :doorkeeper_authorize!
	skip_before_action :doorkeeper_authorize!

	def create
		# puts doorkeeper_token.inspect
		@user = User.new(user_params)
		if @user.save
			build_response_view("custom_ok","Signup successful",{user: @user, status: :created}) 
		else
			build_response_view("custom","Signup failed",{errors: @user.errors.full_messages, status: :unprocessable_entity})
		end  
	end

	private
	def user_params
    params.permit(:email, :password, :fname, :lname, :country_code, :mobile_number)
  end
end
