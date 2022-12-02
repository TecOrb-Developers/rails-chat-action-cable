class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.string :doc_url
      t.string :doc_type
      t.boolean :deleted, default: false
      t.boolean :all_seen, default: false
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
