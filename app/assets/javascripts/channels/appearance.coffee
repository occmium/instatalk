jQuery(document).on 'turbolinks:load', ->

  App.appearance = App.cable.subscriptions.create "AppearanceChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log('Connected to AppearanceChannel')

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log('Disconnected to AppearanceChannel')

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log('Recieved data: ' + data)
    nicknames = []
    data.online_users.forEach (user) ->
      nicknames.push(user.nickname)
      console.log('Users who are online: ' + user.nickname)
    $('#online_users').text(nicknames.join(', '))
