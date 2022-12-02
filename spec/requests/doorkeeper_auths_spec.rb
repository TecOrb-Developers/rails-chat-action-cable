require 'rails_helper'

RSpec.describe "DoorkeeperAuths", type: :request do
  describe "POST /oauth/token" do
    before { 
      @app = create(:doorkeeper_application) # OAuth application
      @user = create(:user, email: "jai@testing.com", password: "123456")
      @headers = { "ACCEPT" => "application/json" } 
      @endpoint = "/oauth/token"
      @bodydata = {
        client_id: @app.uid,
        client_secret: @app.secret
      }
    }
    context 'Login API (get access token)' do
      before {
        @bodydata[:grant_type] = "password"
        @bodydata[:email] = @user.email
        @bodydata[:password] = "123456"
      }

      it "Should be success" do 
        post @endpoint, params: @bodydata, headers: @headers
        # 'response' is a special object which contain HTTP response received after a request is sent
        # response.body is the body of the HTTP response, which here contain a JSON string
        # expect(response.body).to eq('{"status":"online"}')
        # we can also check the http status of the response
        expect(response.status).to eq(200)
      end

      it "Missing grant_type, should be failed" do 
        @bodydata[:grant_type]=nil
        post @endpoint, params: @bodydata, headers: @headers
        expect(response.status).to eq(400)
      end

      it "Missing password, should be failed" do 
        @bodydata[:password] = "1234"
        post @endpoint, params: @bodydata, headers: @headers
        expect(response.status).to eq(400)
      end

      it "Invalid password, should be failed" do 
        @bodydata[:password] = "1234"
        post @endpoint, params: @bodydata, headers: @headers
        expect(response.status).to eq(400)
      end

      it "Missing client_id and secret, should be failed" do 
        @bodydata[:client_id] = nil
        @bodydata[:client_secret]=nil
        post @endpoint, params: @bodydata, headers: @headers
        expect(response.status).to eq(401)
      end

      it "Invalid client_id and secret, should be failed" do 
        @bodydata[:client_id] = "dfsdfasdfdsfasdfasdfasdf"
        @bodydata[:client_secret]= "dsfasdfasd3234234234"
        post @endpoint, params: @bodydata, headers: @headers
        expect(response.status).to eq(401)
      end
    end
  end
end
