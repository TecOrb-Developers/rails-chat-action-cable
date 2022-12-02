class CreateChatDeliveredMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_delivered_messages do |t|
      t.references :chat_message, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :desc

      t.timestamps
    end
  end
end
