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
Run database migrations (migrates `db/migrate/*``):
```
docker-compose run web rails db:migrate
```
Reset the databases:
```
docker-compose run web rails db:reset
```
Browse to <URL>/admin to view the admin login page.


## Authors

**David Provest** - [LinkedIn](https://www.linkedin.com/in/davidjprovest/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
