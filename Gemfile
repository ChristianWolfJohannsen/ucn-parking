source 'https://rubygems.org'
ruby "2.1.1"
gem 'rails', '~> 4.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# If you use a different database in development, hide it from AppFog.
group :development do
	gem 'sqlite3'
end
# Use the pg gem for production.
group :production do
	gem 'pg'
end

group :development, :test do
end

group :test do
  gem "factory_girl_rails", ">= 1.6.0"
  gem "cucumber-rails"
  gem "capybara", ">= 1.1.2"
  gem "database_cleaner"
  gem "launchy"
  gem 'rspec-rails'
end

gem 'thin'
gem 'savon',   '~> 2.0'
gem 'httpclient'
gem 'bootstrap-sass', '~> 2.3'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.0.3'

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Use memcache through Memcachier Heroku add-on
gem 'memcachier'
gem 'dalli'

# For Heroku
gem 'rails_12factor'

# To use debugger
# gem 'debugger'

gem 'newrelic_rpm'
