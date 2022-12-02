require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = build(:user) }
  context 'Testing validations' do
    # before { @user.save }
    it 'Should be success' do
      expect(@user).to be_valid
    end

    it 'Blacklisted email should be failed' do
      @user.email = "example@example.com"
      expect(@user).to_not be_valid
    end

    it 'Blacklisted domain should be failed' do
      @user.email = "example@yahoo.com"
      expect(@user).to_not be_valid
    end

    it 'First name with number should be failed' do
      @user.fname = "namewithnumber1234"
      expect(@user).to_not be_valid
    end

    it 'Last name with number should be failed' do
      @user.lname = "namewithnumber1234"
      expect(@user).to_not be_valid
    end
    
    it 'Missing country code should be failed' do
      @user.country_code = nil
      expect(@user).to_not be_valid
    end

    it 'Missing mobile number should be failed' do
      @user.mobile_number = nil
      expect(@user).to_not be_valid
    end 

    it 'Missing email should be failed' do
      @user.email = nil
      expect(@user).to_not be_valid
    end 

    it 'Duplicate email should be failed' do
      @user.save
      user2 = build(:user, country_code: "#{@user.country_code}1", mobile_number: @user.mobile_number)
      expect(user2).to_not be_valid
    end

    it 'Duplicate mobile number with same country code should be failed' do
      @user.save
      user2 = build(:user, email: "new@user.test", country_code: @user.country_code, mobile_number: @user.mobile_number)
      expect(user2).to_not be_valid
    end

    it 'Duplicate mobile number with different country code should be success' do
      @user.save
      user2 = build(:user, email: "new@user.test", country_code: "#{@user.country_code}1", mobile_number: @user.mobile_number)
      expect(user2).to be_valid
    end  
  end
end
