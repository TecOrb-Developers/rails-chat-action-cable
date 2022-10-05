FactoryBot.define do
  factory :doorkeeper_access_token, class: 'Doorkeeper::AccessToken' do
    application { }
    expires_in { 2.hours }
    scopes { "read write" }
  end
end
