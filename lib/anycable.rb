module Anycable # :nodoc:
  require_relative './anycable/rpc'
  require_relative './anycable/rpc_services'

  class RpcHandler < Anycable::RPC::Service
    def connect(request, _unused_call)
      Rails.logger.debug("RPC Request: #{request};\n#{_unused_call}")

      connection = ApplicationCable::Connection.new(env:
        {
          'HTTP_COOKIE' => request.headers['Cookie'],
          'ORIGINAL_FULLPATH' => request.path
        })

      connection.handle_open

      if connection.closed?
        Anycable::ConnectionResponse.new(status: Anycable::Status::ERROR)
      else
        Anycable::ConnectionResponse.new(
          status: Anycable::Status::SUCCESS,
          identifiers: connection.identifiers_hash.to_json
        )
      end
    end

    def subscribe(message, _unused_call)
      Rails.logger.debug("RPC Subscribe: #{message}")
      Anycable::CommandResponse.new(
        status: Anycable::Status::SUCCESS,
        disconnect: false,
        stop_streams: true,
        stream_from: true,
        stream_id: 'default'
      )
    end

    def unsubscribe(message, _unused_call)
      Rails.logger.debug("RPC Unsubscribe: #{message}")
      Anycable::CommandResponse.new(
        status: Anycable::Status::SUCCESS,
        disconnect: false,
        stop_streams: true,
        stream_from: false
      )
    end

    def perform(message, _unused_call)
      Rails.logger.debug("RPC Perform: #{message}")
      Anycable::CommandResponse.new(
        status: Anycable::Status::SUCCESS,
        disconnect: true
      )
    end
  end
end
