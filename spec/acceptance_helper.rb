require "rails_helper"
require "capybara/rspec"
require "selenium-webdriver"
require "rack_session_access/capybara"
require "puma"

require "bg_helper" if Nenv.cable_url? && !Nenv.skip_bg?

RSpec.configure do |config|
  include ActionView::RecordIdentifier
  config.include AcceptanceHelper, type: :feature
  config.include ShowMeTheCookies, type: :feature

  config.include_context "feature", type: :feature

  Capybara.server = :puma, { Silent: true }
  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = 3002
  Capybara.default_max_wait_time = 5
  Capybara.save_path = "./tmp/capybara_output"
  Capybara.always_include_port = true
  Capybara.raise_server_errors = true

  # See https://github.com/GoogleChrome/puppeteer/issues/1645#issuecomment-356060348
  CHROME_OPTIONS = %w(
    --no-sandbox
    --disable-background-networking
    --disable-default-apps
    --disable-extensions
    --disable-sync
    --disable-gpu
    --disable-translate
    --headless
    --hide-scrollbars
    --metrics-recording-only
    --mute-audio
    --no-first-run
    --safebrowsing-disable-auto-update
    --ignore-certificate-errors
    --ignore-ssl-errors
    --ignore-certificate-errors-spki-list
    --user-data-dir=/tmp
  ).freeze

  Capybara.register_driver :selenium_chrome do |app|
    driver =
      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        options: Selenium::WebDriver::Chrome::Options.new(
          args: CHROME_OPTIONS
        )
      )

    driver.browser.manage.window.size = Selenium::WebDriver::Dimension.new(1024, 740)
    driver
  end

  Capybara.javascript_driver = Capybara.default_driver = :selenium_chrome

  config.append_after(:each) { Capybara.reset_sessions! }
end
