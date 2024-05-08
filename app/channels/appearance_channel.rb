# frozen_string_literal: true

class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    current_user.offline!
  end

  def online
    current_user.online!
  end

  def away
    current_user.away!
  end

  def receive(data)
    message_id = data["message_id"].to_i
    Message.find(message_id).update!(read: true)
  end
end
