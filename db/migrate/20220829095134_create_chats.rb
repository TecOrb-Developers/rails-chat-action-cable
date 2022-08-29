class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.boolean :deleted, default: false
      t.datetime :last_msg_at

      t.timestamps
    end
  end
end
