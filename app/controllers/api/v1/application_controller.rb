class Api::V1::ApplicationController < ActionController::Base
	skip_before_action :verify_authenticity_token
	include ResponseJson
	before_action :doorkeeper_authorize!

	def doorkeeper_unauthorized_render_options(error: nil)
		{ json: { code: 401, error: "Unauthorized access" } }
	end

	def check_logged_user
		@user = User.find_by_id(doorkeeper_token.resource_owner_id) if doorkeeper_token
		unless @user
			build_response_view("unauthorized", nil, {})
		end
	end
end
