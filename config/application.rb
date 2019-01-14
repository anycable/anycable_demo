require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AnyCableDemo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = "Berlin"
    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = Nenv.cable_url
    config.action_cable.mount_path = Nenv.cable_url? ? nil : "/cable"

    config.autoload_paths += %W(#{config.root}/lib)

    config.active_record.sqlite3.represent_boolean_as_integer = true

    if ENV["ANYCABLE_RACK"]
      config.any_cable_rack.run_rpc = true
    end

    # add all upper level assets
    config.assets.precompile +=
    Dir[Rails.root.join('app/assets/*/*.{js,css,coffee,sass,scss}*')]
    .map { |i| File.basename(i).sub(/(\.js)?\.coffee$/, '.js') }
    .map { |i| File.basename(i).sub(/(\.css)?\.(sass|scss)$/, '.css') }
    .reject { |i| i =~ /^application\.(js|css)$/ }

    config.generators do |g|
      g.assets          false
      g.helper          false
      g.orm             :active_record
      g.template_engine :slim
      g.stylesheets     false
      g.javascripts     false
      g.test_framework  false
    end
  end
end
