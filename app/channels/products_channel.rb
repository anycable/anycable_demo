class ProductsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "baskets/#{data['id']}"
  end

  def unsubscribed
    ActionCable.server.broadcast(
      "notifications",
      type: 'notice', data: "#{current_user} left this basket page"
    )
  end
end
