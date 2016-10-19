class ProductsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "baskets/#{data['id']}"
  end
end
