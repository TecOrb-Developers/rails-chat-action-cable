class ChatRemove < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  has_many :chat_remove_logs, dependent: :destroy
  # How Chat Remove works when user will remove a chat:
  # Case 1. A record in chat_removes will create (deleted: true) for the user and chat
  # Case 2. When any new message will come, chat_remove's deleted will be false, now chat will be listed again
end
