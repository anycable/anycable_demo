class ProductsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "baskets/#{data['id']}"
  end

  def unsubcribed
    ActionCable.server.broadcast(
      "notifications",
      type: 'notice', data: "#{current_user} left basket page"
    )
  end
end
