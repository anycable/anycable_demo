require 'anycable/config'
require 'anycable/actioncable/server'

module Anycable # :nodoc:
  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new('/dev/null')
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config) if block_given?
  end
end
