FactoryBot.define do
  factory :user do
    fname { "Test" }
    lname { "user" }
    email { "testing@mydomain.com" }
    password { "password" }
    country_code { "+91" }
    mobile_number { "4444444444" }
    dob { "1993-10-04 15:58:36" }
  end
end
