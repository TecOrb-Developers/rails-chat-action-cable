class CreateChatRemoveLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_remove_logs do |t|
      t.references :chat_remove, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :category, default: "removed"
      t.string :description

      t.timestamps
    end
  end
end
