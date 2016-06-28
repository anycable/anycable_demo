module AnycableRefinements
  refine ActionCable::Connection::Base do
    attr_reader :transmissions

    def initialize
      @coder = ActiveSupport::JSON
      @transmissions = []
    end

    def handle_open
      connect if respond_to?(:connect)
      send_welcome_message
    rescue ActionCable::Connection::Authorization::UnauthorizedError
      close
    end

    def handle_close
      # subscriptions.unsubscribe_from_all
      disconnect if respond_to?(:disconnect)
    end

    def close
      @closed = true
    end

    def transmit(cable_message)
      transmissions << encode(cable_message)
    end

    def dispose
      @closed = false
      transmissions.clear
    end
  end
end
