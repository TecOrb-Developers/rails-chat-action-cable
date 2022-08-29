class CreateChatRemoves < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_removes do |t|
      t.boolean :deleted, default: true
      t.references :chat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
