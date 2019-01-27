# Fooni 2019
A modernisation of the first Rails app I built in university in Rails 4.<br/>
The app is a central portal to find food and events on campus.<br/>
<br/>
Note: Use `grip` to view README.md formatting is as desired.<br/>
[Download Grip](https://github.com/joeyespo/grip)

## Create a Hello World Rails 5 Dockerised App
[Link to Hello World Rails 5 Dockerised App](https://github.com/dpro7026/helloworld_rails_docker)

## Add a Homepage and Bootstrap 4
Generate a Homepage with an index action:
```
docker-compose run web rails g controller Homepage index
```
Update the root URL in `config/routes.rb`:
```
Rails.application.routes.draw do
  get 'homepage/index'
  root 'homepage#index'
end
```
Add a Bootstrap button to `app/views/homepage/index.html.erb`:
```
<h1>Homepage</h1>
<button type="button" class="btn btn-primary">Button</button>
```
Refresh the app and see the button is not styled yet.<br/>
Add to the `Gemfile` (not in a group) the following:
```
# Add Bootstrap 4 for CSS styling
gem 'bootstrap', '~> 4.2.1'
# Add JQuery as Rails 5 doesn't include this by default
gem 'jquery-rails'
```
Update the bundle and install the gems:
```
docker-compose run web bundle update
```
Build the Docker image (required anytime the Gemfile is modified):
```
docker-compose build
```
Run the following command to rename the `application.css` to `application.scss`, this changes the file extension.
```
mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss
```
Open the `app/assets/stylesheets/application.scss` and replace the contents with:
```
@import "bootstrap";
```
Open app/assets/javascripts/application.js above //= require_tree .:
```
//= require jquery3
//= require popper
//= require bootstrap-sprockets
```
Refresh the page to see the style button.

## Add Devise and Active Admin
Add Devise gem to the `Gemfile`:
```
# For user authentication
gem 'devise', '~> 4.3'
```
Update the bundle and install the gems:
```
docker-compose run web bundle update
```
Build the Docker image (required anytime the `Gemfile` is modified):
```
docker-compose build
```
Run devise generator (read the instruction output):
```
docker-compose run web rails generate devise:install
```
Add the following to `config/environments/development.rb`:
```
# define default url options for mailer
config.action_mailer.default_url_options = { host: ENV['IP'], port: ENV['PORT'] }
```
Add Activeadmin gem to the Gemfile:
```
# For managing admins
gem 'activeadmin', '~> 1.1'
```
Update the bundle and install the gems:
```
docker-compose run web bundle update
```
Build the Docker image (required anytime the `Gemfile` is modified):
```
docker-compose build
```
Run Activeadmin generator:
```
docker-compose run web rails g active_admin:install
```
We ALWAYS want to change the default admin credentials. Open `db/seeds.rb` and update the admin credentials.
```
if Rails.env.development?
    AdminUser.create!(email: 'admin@example.com', password: 'admin1', password_confirmation: 'admin1')
end
```
Run database migrations (migrates `db/migrate/*`):
```
docker-compose run web rails db:migrate
```
Reset the databases:
```
docker-compose run web rails db:reset
```
Browse to <URL>/admin to view the admin login page.

## Add Users and Events
Add users using Devise generator:
```
docker-compose run web rails generate devise User
```
Update the migration file `<timestamp>_devise_create_users.rb` with additional columns:
```
create_table :users do |t|
  ## Adding our own additional columns to the User table
  t.string :username,           null: false
  t.string :name
  t.string :facebook
  t.text :description
  t.string :role

  ## Database authenticatable
  t.string :email,              null: false, default: ""
  t.string :encrypted_password, null: false, default: ""
  ...
```
Generate an Event scaffold:
```
docker-compose run web rails g scaffold Event name:string description:text location:string member_price:decimal non_member_price:decimal start_datetime:datetime end_datetime:datetime
```
Update the root in `config/routes.rb`:
```
root 'events#index'
```
Update the `db/seeds.rb` with a default user:
```
if Rails.env.development?
    AdminUser.create!(email: 'admin@example.com', password: 'admin1', password_confirmation: 'admin1')

    engsoc = User.create!(
      username: 'EngSoc',
      name: 'Engineering Society',
      email: 'engsoc@mail.com',
      password: 'password1',
      password_confirmation: 'password1',
      role: 'organisation',
      description: 'Engineering Society at the University of Sydney'
    )

    event1 = Event.create!(
      name: 'BBQ',
    	description: 'Let\'s celebrate the beginning of the semester with some free BBQ!',
    	member_price: 0.00,
    	non_member_price: 0.00,
    	location: 'Engineering Laws',
    	start_datetime: DateTime.new(2015,9,5,12,0),
    	end_datetime: DateTime.new(2015,9,5,13,0)
    )
end
```
Run database migrations:
```
docker-compose run web rails db:migrate
```
Reset the databases:
```
docker-compose run web rails db:reset
```

## Add Associations
We update the Event to belong to a User by deleting and creating a new scaffold.<br/>
Destroy the existing scaffold:
```
docker-compose run web rails d scaffold Event
```
Drop the databases so we don't have any inconsistencies:
```
docker-compose run web rails db:drop db:create
```
Generate a new Event scaffold referencing the belongs to User:
```
docker-compose run web rails g scaffold Event name:string description:text location:string member_price:decimal non_member_price:decimal start_datetime:datetime end_datetime:datetime user:references
```
Run the migrations:
```
docker-compose run web rails db:migrate
```
Update the event to have a user in `db/seeds.rb`:
```
event1 = Event.create!(
  name: 'BBQ',
  description: 'Let\'s celebrate the beginning of the semester with some free BBQ!',
  member_price: 0.00,
  non_member_price: 0.00,
  location: 'Engineering Laws',
  start_datetime: DateTime.new(2015,9,5,12,0),
  end_datetime: DateTime.new(2015,9,5,13,0),
  user: engsoc
)
```
Reset the database with the new seeds:
```
docker-compose run web rails db:reset
```
Add an association in `app/models/user.rb` to destroy the Event if the User is destroyed:
```
has_many :events, dependent: :destroy
```

## Add Factory Bot, Faker and RSpec for Testing
Add to the `Gemfile` into the group :development, :test do:
```
# Testing framework
gem 'rspec-rails'
# Use factories to create sample instances of objects
gem 'factory_bot_rails'
# Use faker to generate sample data
gem 'faker'
```
Update the bundle and install the gems:
```
docker-compose run web bundle update
```
Re-build the container after updating `Gemfile`:
```
docker-compose build
```
Generate the RSpec configuration:
```
docker-compose run web rails generate rspec:install
```
Ensure the correct version of RSpec is used:
```
docker-compose run web bundle binstubs rspec-core
```
Create a new folder `spec/support` containing a file `factory_bot.rb`. Add the following initialiser configuration to this file:
```
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```
Our first test scenario will be validating that a User email is not nil.<br/>
Create a new folder `spec/factories` containing a file `users.rb` containing:
```
FactoryBot.define do
  factory :user do
    username { 'John Soc' }
    email { 'john@example.com' }
    password { 'password' }
    name { 'John\'s Society' }
    role { 'organisation' }
    description { 'Hi I\'m John and I like to Party!' }
  end

  factory :user_without_email, class: User do
    username { 'John Soc' }

    password { 'password' }
    name { 'John\'s Society' }
    role { 'organisation' }
    description { 'Hi I\'m John and I like to Party!' }
  end

  factory :random_user, class: User do
    username { Faker::Pokemon.name }
    email { Faker::Internet.safe_email }
    password { 'password' }
    name { Faker::FunnyName.two_word_name }
    role { 'organisation' }
    description { Faker::Lorem.sentence(3) }
  end
end
```
Create a new folder `spec/features` with a file `create_user_spec.rb` containing:<br/>
Note: I'm using feature, scenario and given syntax. However, feature is an alias for describe, background is an alias for before, scenario for it, and given/given! aliases for let/let!, respectively.
```
require 'rails_helper'
require 'support/factory_bot'

RSpec.feature 'User fields are validated' do
  given(:user_without_email) { build(:user_without_email) }

  scenario 'Email is not present' do
    expect(user_without_email.save).to eq(false)
  end

  scenario 'Email is present' do
    user_without_email.email = "john@example.com"
    expect(user_without_email.save).to eq(true)
  end
end
```
Run RSpec and see that the first test fails and the second test passes:
```
docker-compose run web rspec
```
Now add to `app/models/user.rb` the validation to make the test pass:
```
validates :email, presence: true
```
Run RSpec again and see that both scenarios pass:
```
docker-compose run web rspec
```


## Authors

**David Provest** - [LinkedIn](https://www.linkedin.com/in/davidjprovest/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
