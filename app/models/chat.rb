class Chat < ApplicationRecord
  belongs_to :user
  has_many :chat_removes, dependent: :destroy
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users
  has_many :chat_messages, dependent: :destroy
  has_many :chat_message_seens, through: :chat_messages
  has_many :chat_deleted_messages, through: :chat_messages
  has_many :chat_delivered_messages, through: :chat_messages
end
