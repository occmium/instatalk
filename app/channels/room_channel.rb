class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    logger.info "Subscribed to RoomChannel, roomId: #{params[:roomId]}"

    @room = Room.find(params[:roomId])

    # Если сервер увидит что-то, что предназначено для room_channel,
    # то он отправит это в JavaScript
    stream_from "room_channel_#{@room.id}"

    # Пишем сообщение, что юзер зашёл в чат
    speak('message' => '* * * joined the room * * *')
  end

  def unsubscribed
    logger.info "Unsubscribed to RoomChannel"
    # Any cleanup needed when channel is unsubscribed

    # Пишем сообщение, что юзер покинул чат
    speak('message' => '* * * left the room * * *')
  end

  def speak(data)
    logger.info "RoomChannel, speak: #{data.inspect}"

    # Вызываем сервис
    MessageService.new(
      body: data['message'], user: current_user, room: @room
      # body: data['message'], room: @room, user: current_user
    ).perform

    # Этот код нужен для того, чтобы сообщение получили все подписчики канала
    # ActionCable.server.broadcast "room_channel_#{@room.id}", message: data['message']
  end
end
