class NotificationChannel < ApplicationCable::Channel
  def follow
    stop_all_streams
    stream_from "notifications_#{params['id']}"
    stream_from "notifications"
    transmit type: 'notice', data: "Welcome, #{current_user}!"
  end

  def unsubscribed
    # Wow! Action Cable cannot handle this(
    # transmit type: 'success', data: 'Notifications turned off. Good-bye!'
  end
end
