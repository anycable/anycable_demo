# Load the Rails application.
require_relative 'application'

require 'faker/food'
require 'anycable' if Nenv.cable_url?

# Initialize the Rails application.
Rails.application.initialize!
