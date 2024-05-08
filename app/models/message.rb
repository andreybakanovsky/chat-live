# frozen_string_literal: true

class Message < ApplicationRecord
  after_create_commit { broadcast_number_of_new_messages }
  after_update_commit { broadcast_number_of_new_messages }
  after_update_commit { broadcast_status }

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :content, presence: true

  scope :private_between, lambda { |current_user, recipient|
                            where('(sender_id = :current_user_id AND recipient_id = :recipient_id)
                           OR (sender_id = :recipient_id AND recipient_id = :current_user_id)',
                                  current_user_id: current_user.id, recipient_id: recipient.id).order(created_at: :asc)
                          }
  scope :common_between, lambda { |current_user, common_chat_user|
                           where('(sender_id = :current_user_id AND recipient_id = :recipient_id)
                              OR (recipient_id = :recipient_id)',
                                 current_user_id: current_user.id, recipient_id: common_chat_user.id).order(created_at: :asc)
                         }
  scope :received, ->(recipient_id, sender_id) { where(sender_id:).where(recipient_id:) }
  scope :unread, -> { where(read: false) }

  def broadcast_number_of_new_messages
    NewMessageNotificationJob.perform_later(self)
  end

  def broadcast_status
    broadcast_replace_to :message_status, target: "message_#{id}",
                                          partial: "messages/message",
                                          locals: { message: self,
                                                    current_user: User.find(recipient_id) }
  end
end
