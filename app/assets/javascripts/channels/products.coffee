#= require ./base

window.ProductsChannel = Object.assign({
  handle_connected: ->
    @perform 'follow', id: gon.basket_id
  name: -> 'ProductsChannel'
}, BaseChannel)

