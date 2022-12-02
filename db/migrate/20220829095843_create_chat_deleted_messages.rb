class CreateChatDeletedMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_deleted_messages do |t|
      t.references :chat_message, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
