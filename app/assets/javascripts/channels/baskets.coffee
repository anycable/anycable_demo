#= require ./base

window.BasketsChannel = Object.assign({
  handle_connected: -> @perform 'follow',
  name: -> 'BasketsChannel'
}, BaseChannel)

