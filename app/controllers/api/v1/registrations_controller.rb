class Api::V1::RegistrationsController < Api::V1::ApplicationController
	def create
		puts doorkeeper_token.inspect
		sendResponse("customOk","Best",{data: 300})   
	end
end
