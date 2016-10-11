class ProductsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "baskets/#{data['id']}"
  end
end
