#= require ./base

window.NotificationChannel = Object.assign({
  handle_connected: -> @perform 'follow'
  name: -> 'NotificationChannel'
}, BaseChannel)

