require 'rails_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'
require "rack_session_access/capybara"
require "puma"

require "bg_helper" if Nenv.cable_url? && !Nenv.skip_bg?

RSpec.configure do |config|
  include ActionView::RecordIdentifier
  config.include AcceptanceHelper, type: :feature
  config.include ShowMeTheCookies, type: :feature

  config.include_context "feature", type: :feature

  Capybara.server_host = ENV['HOST'] || "localhost"
  Capybara.server_port = 3001 + ENV['TEST_ENV_NUMBER'].to_i
  Capybara.default_max_wait_time = 10
  Capybara.save_path = "./tmp/capybara_output"
  Capybara.always_include_port = true # for correct app_host

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      timeout: 90, js_errors: true,
      window_size: [1060, 800]
    )
  end

  Capybara.javascript_driver = :poltergeist

  Capybara.server = :puma

  config.append_after(:each) { Capybara.reset_sessions! }
end
