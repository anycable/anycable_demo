class window.Notifications
  on: ->
    return if @active

    @active = true

    @notificationChannel = App.cable.subscriptions.create(
      { channel: 'NotificationChannel', id: gon.user_id },
      NotificationChannel
    )

    @notificationChannel.handle_message = (type, data) ->
      if type is 'alert'
        App.utils.errorMessage(data)
      else if type is 'success'
        App.utils.successMessage(data)
      else
        App.utils.simpleMessage(data)
  
  off: ->
    return unless @active

    @active = false
    @notificationChannel.unsubscribe()
