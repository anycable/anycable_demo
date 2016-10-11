class BasketsChannel < ApplicationCable::Channel
  def follow
    stream_from "baskets"
  end
end
