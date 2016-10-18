module ActionCable::Channel::Streams
  def worker_pool_stream_handler(broadcasting, user_handler, coder: nil)
    { connection: connection, id: @identifier.to_json }
  end
end

class ActionCable::SubscriptionAdapter::SubscriberMap
  def invoke_callback(callback, message)
    callback[:connection].send(:websocket).transmit(
      "{\"identifier\": #{callback[:id]},\"message\": #{message}}"
    )
  end
end
