# Load the Rails application.
require_relative 'application'

require 'faker/food'
require 'anycable-rails' if Nenv.cable_url?

# Initialize the Rails application.
Rails.application.initialize!
