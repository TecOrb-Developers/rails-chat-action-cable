class ChatRemoveLog < ApplicationRecord
  belongs_to :chat_remove
  belongs_to :user
end
