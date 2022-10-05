require 'rails_helper'

RSpec.describe Doorkeeper::AccessToken, type: :model do
  context 'Doorkeeper Access Token Auth' do
    before { 
      @app = create(:doorkeeper_application) # OAuth application
      @user = create(:user)
    }
    
    it 'Should create token' do
      @token = create(:doorkeeper_access_token, application: @app, resource_owner_id: @user.id, scopes: "read write")
      expect(@token).to be_valid
    end
  end
end
