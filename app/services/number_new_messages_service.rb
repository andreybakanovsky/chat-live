# frozen_string_literal: true

class NumberNewMessagesService
  def initialize(recipient_id:, sender_id:)
    @recipient_id = recipient_id
    @sender_id = sender_id
  end

  def perform
    number = Message.received(@recipient_id, @sender_id).unread.count
    number.zero? ? '' : number.to_s
  end
end
