require 'anycable/actioncable/connection'
require 'anycable/actioncable/channel'
require 'anycable/rpc'
require 'anycable/rpc_services'

module Anycable
  class RPCHandler < Anycable::RPC::Service
    def connect(request, _unused_call)
      Anycable.logger.debug("RPC Connect: #{request}")

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
          identifiers: connection.identifiers_hash.to_json,
          transmissions: connection.transmissions
        )
      end
    end

    def disconnect(request, _unused_call)
      Anycable.logger.debug("RPC Disonnect: #{request}")

      Anycable::DisconnectResponse.new(status: Anycable::Status::SUCCESS)
    end

    def subscribe(message, _unused_call)
      Anycable.logger.debug("RPC Subscribe: #{message}")
      connection = ApplicationCable::Connection.new(identifiers_json: message.connection_identifiers)

      channel = channel_for(connection, message)

      if channel.present?
        channel.do_subscribe
        if channel.subscription_rejected?
          Anycable::CommandResponse.new(
            status: Anycable::Status::ERROR,
            disconnect: connection.closed?
          )
        else
          Anycable::CommandResponse.new(
            status: Anycable::Status::SUCCESS,
            disconnect: connection.closed?,
            stop_streams: channel.stop_streams?,
            stream_from: channel.streams.present?,
            stream_id: channel.streams.first || '',
            transmissions: connection.transmissions
          )
        end
      else
        Anycable::CommandResponse.new(
          status: Anycable::Status::ERROR
        )
      end
    end

    def unsubscribe(message, _unused_call)
      Anycable.logger.debug("RPC Unsubscribe: #{message}")
      Anycable::CommandResponse.new(
        status: Anycable::Status::SUCCESS,
        disconnect: false,
        stop_streams: true,
        stream_from: false
      )
    end

    def perform(message, _unused_call)
      Anycable.logger.debug("RPC Perform: #{message}")
      connection = ApplicationCable::Connection.new(identifiers_json: message.connection_identifiers)

      channel = channel_for(connection, message)

      if channel.present?
        channel.perform_action(ActiveSupport::JSON.decode(message.data))
        Anycable::CommandResponse.new(
          status: Anycable::Status::SUCCESS,
          disconnect: connection.closed?,
          stop_streams: channel.stop_streams?,
          stream_from: channel.streams.present?,
          stream_id: channel.streams.first || '',
          transmissions: connection.transmissions
        )
      else
        Anycable::CommandResponse.new(
          status: Anycable::Status::ERROR
        )
      end
    end

    private

    def channel_for(connection, message)
      id_key = message.identifier
      id_options = ActiveSupport::JSON.decode(id_key).with_indifferent_access

      subscription_klass = id_options[:channel].safe_constantize

      if subscription_klass
        subscription_klass.new(connection, id_key, id_options)
      else
        logger.error "Subscription class not found (#{data.inspect})"
      end
    end
  end
end
