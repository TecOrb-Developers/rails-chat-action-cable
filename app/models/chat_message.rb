class ChatMessage < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  has_many :chat_message_seens, dependent: :destroy
  has_many :chat_deleted_messages, dependent: :destroy
  has_many :chat_delivered_messages, dependent: :destroy
end
