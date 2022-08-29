class Api::V1::RegistrationsController < Api::V1::ApplicationController
	def create
		puts doorkeeper_token.inspect
		build_response_view("customOk","Best",{data: 300})   
	end
end
