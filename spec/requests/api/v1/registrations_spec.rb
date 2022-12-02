require 'rails_helper'

RSpec.describe "Api::V1::Registrations", type: :request do
  describe "POST /api/v1/registrations" do
    context 'Signup API' do
      # All model's validations are tested in model rspec so we need to test
      # registration API instead of all validations
      before { 
        @headers = { "ACCEPT" => "application/json" } 
        @endpoint = "/api/v1/registrations"
      }

      it "Should be success" do 
        user_data = attributes_for(:user)

        post @endpoint, params: user_data, headers: @headers
        # 'response' is a special object which contain HTTP response received after a request is sent
        # response.body is the body of the HTTP response, which here contain a JSON string
        # expect(response.body).to eq('{"status":"online"}')
      
        # we can also check the http status of the response
        expect(response.status).to eq(200)
      end

      it "Should be failed" do 
        user_data = attributes_for(:user).merge(email: nil)
        post @endpoint, params: user_data, headers: @headers
        # we can also check the http status of the response
        expect(response.status).to eq(422)
      end
    end
  end
end
