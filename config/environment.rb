# Load the Rails application.
require_relative 'application'

require 'faker/food'
require 'anycable' if Nenv.cable_url?
require_relative '../lib/actioncable_patch' if Nenv.patch?

# Initialize the Rails application.
Rails.application.initialize!
