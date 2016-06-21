window.BaseChannel = {
  log: (msg) ->
    App.utils.successMessage("[ActionCable##{@name()}] #{msg}")

  connected: ->
    @log 'Connected'
    after 100, => @handle_connected?()

  disconnected: ->
    @log 'Disconnected'

  received: (data) ->
    @log 'Message Received'
    @handle_message?(data.type, data.data)
}