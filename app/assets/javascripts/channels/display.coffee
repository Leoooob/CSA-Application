App.display = App.cable.subscriptions.create "DisplayChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    # $('messages').prepend('Web Socket connected')

  disconnected: ->
    # Called when the subscription has been terminated by the server
    # $('messages').prepend('Web Socket disconnected')

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # console.log("data message:" + data['message'] )
    # console.log("data message:" + data['time_stamp'] )
    $('#messages').prepend(data['message'] + data['time_stamp'])
