jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')

  if messages.length > 0
    createRoomChannel messages.data('room-id')
    scrollBottom(messages)

  $(document).on 'keypress', '#message_body', (event) ->
    message = event.target.value
#    if event.keyCode is 13 && message != ''
# "==" и "is" это синонимичные операторы в CoffeeScript
    if event.keyCode == 13 && message != ''
      App.room.speak(message)
      event.target.value = ""
    event.preventDefault()
# правильный отступ важен в CoffeeScript (чтоб возвращалось к дефолтному виду
# только не зависимо от вышестоящего условия)

createRoomChannel = (roomId) ->
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", roomId: roomId},
    connected: ->
# Called when the subscription is ready for use on the server
      console.log('Connected to RoomChannel')

    disconnected: ->
# Called when the subscription has been terminated by the server
      console.log('Disconnected from RoomChannel')

    received: (data) ->
# Called when there's incoming data on the websocket for this channel
      console.log('Received message: ' + data['message'])
      $('#messages').append data['message']
      scrollBottom(messages)

    speak: (message) ->
      @perform 'speak', message: message
