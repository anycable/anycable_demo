require 'anyway'

module Anycable
  # Influxer configuration
  class Config < Anyway::Config
    config_name :cable

    attr_config rpc_host: 'localhost:50051',
                redis_url: 'redis://localhost:6379/5',
                redis_channel: 'anycable'
  end
end
