class BasketsChannel < ApplicationCable::Channel
  def follow
    stop_all_streams
    stream_from "baskets"
  end
end
