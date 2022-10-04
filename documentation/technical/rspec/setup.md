### Rspec setup
1. Added gem to `Gemfile` and did `bundle install`
````
group :development, :test do
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'main'
  end
end
````
2. Then generated rspec helpers via:

`rails generate rspec:install`

Above created some helpers and rspec files, mentioned below

      create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb

3. Generated spec files for our models

RSpec also provides its own spec file generators. Like below is an example of generating spec file for *User* model

`rails generate rspec:model user`

Above will generate a spec file for our model as mentioned below 

      create  spec/models/user_spec.rb

4. Generated spec files for our controllers

Below is an example of generating spec file for *api/v1/registrations_controller*

`rails generate rspec:controller api/v1/registrations`

Above will generate a spec file for the given controller as mentioned below

      create  spec/requests/api/v1/registrations_spec.rb

5. Now we are ready to write tests

6. Run specs tests

Run specific spec file: 

`rspec spec/requests/api/v1/registrations_spec.rb`

Run all specs:

`rspec`