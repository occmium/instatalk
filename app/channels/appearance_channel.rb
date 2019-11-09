class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance_channel"

    if current_user
      current_user.update_attribute(:online, true)
      broadcast_online_users
    end
  end

  def unsubscribed
    if current_user
      current_user.update_attribute(:online, false)
      broadcast_online_users
    end
  end

  def broadcast_online_users
    online_users = User.where(online: true)
    ActionCable.server.broadcast "appearance_channel", { online_users: online_users.as_json }
  end
end
