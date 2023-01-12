### Update Your Gemfile

If you're using Rails:

```ruby
gem 'factory_bot_rails', '~> 6.1'
```
Note: FactoryBot was previously named FactoryGirl

### Configure your test suite

#### RSpec

If you're using Rails, add the following configuration to
`spec/support/factory_bot.rb` 

``
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
``

Require above file in `rails_helper.rb` file:

`Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }`

### Generate Factory for model

Here is the command to create a factory:

`rails g factory_bot:model User fname lname email dob:datetime password`

Remember, when you use rails g, you can always undo it, with rails d

`rails d factory_bot:model User fname lname email dob:datetime password`

### Specifying the class explicitly

It is also possible to explicitly specify the class:

````
# This will use the User class (otherwise Admin would have been guessed)
factory :admin, class: "User"
````

### Using factories

factory_bot supports several different build strategies: build, create, attributes_for and build_stubbed:

```
# Returns a User instance that's not saved
user = build(:user)

# Returns a saved User instance
user = create(:user)

# Returns a hash of attributes that can be used to build a User instance
attrs = attributes_for(:user)

# Returns an object with all defined attributes stubbed out
stub = build_stubbed(:user)

# Passing a block to any of the methods above will yield the return object
create(:user) do |user|
  user.posts.create(attributes_for(:post))
end
```
