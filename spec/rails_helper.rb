# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'factory_girl_rails'
require "faker/food"

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/shared_contexts/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/shared_examples/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Rails.logger = ActionCable.server.config.logger = ActiveRecord::Base.logger = Logger.new(STDOUT) if Nenv.log?

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    Zonebie.set_random_timezone
  end

  config.before(:each) { DatabaseCleaner.strategy = :transaction }

  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }

  config.before(:each) { DatabaseCleaner.start }

  config.after(:each) do
    # Clear Rails cache
    Rails.cache.clear
    # Clean DB
    DatabaseCleaner.clean
    # Timecop
    Timecop.return
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.infer_base_class_for_anonymous_controllers = false

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
  config.filter_gems_from_backtrace 'active_model_serializers'
end
