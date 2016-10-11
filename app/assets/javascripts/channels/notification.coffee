#= require ./base

window.NotificationChannel = Object.assign({
  handle_connected: -> @perform 'follow', id: gon.user_id
  name: -> 'NotificationChannel'
}, BaseChannel)

