class NotificationChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "notifications_#{data['id']}"
    stream_from "notifications"
  end
end
