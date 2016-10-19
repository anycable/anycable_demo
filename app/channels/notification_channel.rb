class NotificationChannel < ApplicationCable::Channel
  def follow
    stop_all_streams
    stream_from "notifications_#{params['id']}"
    stream_from "notifications"
  end
end
