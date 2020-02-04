source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Use sqlite3
gem 'sqlite3', '~> 1.4', group: [:development, :test]
gem 'pg', group: :production

# Use Puma as the app server
gem 'puma', '~> 4.0'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.0'
gem 'slim-rails'
gem 'autoprefixer-rails'
gem 'csso-rails'
gem 'jquery-rails'
gem 'materialize-sass', '~> 0.100'
gem 'material_icons'
gem 'skim'
gem 'gon'

gem 'redis', '~> 4.0'

gem 'rack-cors'

# Other
gem 'nenv'

if ENV["LOCAL_CABLE"]
  gem 'anycable', path: '../anycable'
  gem 'anycable-rails', path: '../anycable-rails'
else
  gem 'anycable-rails', '~> 0.6.4'
end

gem 'anycable-rack-server', require: ENV["ANYCABLE_RACK"] ? "anycable-rack-server" : false

gem 'yabeda'

gem 'prometheus-client'
gem 'yabeda-prometheus'

gem 'tzinfo'
gem 'tzinfo-data'

gem 'active_model_serializers'

gem 'factory_girl_rails', '~> 4.0'

gem "faker", "~> 1.8.4"

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'listen', '~> 3.0.5'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors'
  gem 'binding_of_caller'

  # Code audit
  gem 'rubocop', require: false
end

group :test do
  # RSpec tools
  gem 'rspec-rails', '~> 3.5.0'
  gem "rspec_junit_formatter" # For CircleCI reports
  gem 'capybara'
  gem 'fuubar'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'zonebie'
  gem 'json_spec'
  gem 'show_me_the_cookies'

  gem 'chromedriver-helper'
  gem 'selenium-webdriver', require: false

  gem 'rack_session_access'
end
