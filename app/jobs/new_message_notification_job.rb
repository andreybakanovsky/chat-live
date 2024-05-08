# frozen_string_literal: true

class NewMessageNotificationJob < ApplicationJob
  queue_as :default

  def perform(message)
    recipient = User.find(message.recipient_id)

    AppearanceChannel.broadcast_to(recipient, new_message: "message_#{message.id}",
                                              sender_id: message.sender_id.to_s,
                                              new_messages_number: new_messages_number(message))
  end

  private

  def new_messages_number(message)
    NumberNewMessagesService.new(recipient_id: message.recipient_id, sender_id: message.sender_id)
                            .perform
  end
end
