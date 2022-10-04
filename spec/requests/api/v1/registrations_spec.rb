require 'rails_helper'

RSpec.describe "Api::V1::Registrations", type: :request do
  describe "POST /api/v1/registrations" do
    context 'Testing validations' do
      it 'Success' do
        user = create(:user)
      end

      it 'Blacklisted email' do
        user = create(:user)
      end

      it 'Blacklisted domain' do
        user = create(:user)
      end

      it 'First name with number' do
        user = create(:user)
      end

      it 'Last name with number' do
        user = create(:user)
      end
      
      it 'Missing country code' do
        user = create(:user)
      end

      it 'Missing mobile number' do
        user = create(:user)
      end 

      it 'Missing email' do
        user = create(:user)
      end 

      it 'Duplicate mobile number with same country code' do
        user = create(:user)
      end

      it 'Duplicate mobile number with different country code' do
        user = create(:user)
      end  

      it 'Duplicate email' do
        user = create(:user)
      end
    end
  end
end
