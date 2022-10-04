FactoryBot.define do
  factory :doorkeeper_application, class: "Doorkeeper::Application" do
    name { "My Application" }
    scopes { "read write" }
    confidential { false }
    redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
  end
end
