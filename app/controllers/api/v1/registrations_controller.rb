class Api::V1::RegistrationsController < Api::V1::ApplicationController
	skip_before_action :doorkeeper_authorize!

	def create
		@user = User.new(user_params)
		if @user.save
			render json: @user.decorate, serializer: UserSerializer
		else
			render_error @user.errors.full_messages
		end  
	end

	private
	def user_params
		params.permit(:email, :password, :fname, :lname, :country_code, :mobile_number)
	end
end
