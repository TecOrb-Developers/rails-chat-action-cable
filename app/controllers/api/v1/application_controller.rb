class Api::V1::ApplicationController < ActionController::Base
	skip_before_action :verify_authenticity_token
	include Api::V1::ApplicationHelper
	before_action :doorkeeper_authorize!

	def doorkeeper_unauthorized_render_options(error: nil)
		{ json: { errors: error.description } }
	end

	def check_logged_user
		unless current_user
			render_error "Unauthorized access"
		end
	end

	def current_user
		@user = User.find_by_id(doorkeeper_token.resource_owner_id).decorate if doorkeeper_token
	end

	def render_error(errors, status = :unprocessable_entity)
		render json: { errors: errors, }, status: status
	end

	def render_success(message = "success", status = :ok)
		render json: { message: message, }, status: status
	end
end
