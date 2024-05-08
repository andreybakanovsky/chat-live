# frozen_string_literal: true

class AddReadFlagToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :read, :boolean, null: false, default: false
  end
end
