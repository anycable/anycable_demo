module Anycable # :nodoc:
  require_relative './any_rpc/connector'
  require_relative './any_rpc/connector_services'

  class RPC < Anycable::Connector::Service
    def connect(request, _unused_call)
      Rails.logger.debug("RPC Request: #{request};\n#{_unused_call}")
      Anycable::ConnectionResponse.new(status: Anycable::ConnectionStatus::SUCCESS)
    end
  end
end
