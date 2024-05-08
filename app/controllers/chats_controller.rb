# frozen_string_literal: true

class ChatsController < ApplicationController
  def index
    users
  end

  def show
    token
    users_messages
    render 'index'
  end

  private

  helper_method def new_messages_number(recipient_id, sender_id)
    NumberNewMessagesService.new(recipient_id:, sender_id:).perform
  end

  helper_method def recipient
    @recipient ||= User.find(params[:id])
  end

  helper_method def users
    @users ||= User.where.not(id: current_user.id).order(id: :asc)
  end

  def users_messages
    @users_messages ||= if recipient.as_common_chat?
                          Message.common_between(current_user, recipient).includes(:sender).includes(:recipient)
                        else
                          Message.private_between(current_user, recipient).includes(:sender).includes(:recipient)
                        end
  end

  def token
    return @token ||= users_messages.first.token if users_messages.exists?
    return @token = "" if recipient.as_common_chat?

    @token = calculate_token
  end

  def calculate_token
    if current_user.id < recipient.id
      "#{current_user.id}_#{recipient.id}"
    else
      "#{recipient.id}_#{current_user.id}"
    end
  end
end
