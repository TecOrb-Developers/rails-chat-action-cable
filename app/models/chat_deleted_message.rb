class ChatDeletedMessage < ApplicationRecord
  belongs_to :chat_message
  belongs_to :user
end
