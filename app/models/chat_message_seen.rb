class ChatMessageSeen < ApplicationRecord
  belongs_to :chat_message
  belongs_to :user

  after_save :update_seen_message

  def update_seen_message
    # This is for when all group users will seen a message then ChatMessage allSeen will be seen
    msg = chat_message
    seenby_user_ids = msg.chat_message_seens.where("user_id != ?", msg.user_id).pluck(:user_id).uniq.count
    chat_user_ids = msg.chat.chat_users.where("user_id != ?", msg.user_id).pluck(:user_id).uniq.count
    msg.update(all_seen: true) if seenby_user_ids >= chat_user_ids

    # 12 Code for action cable to message Seen
    CableNotifyChatJob.perform_async(12, msg.chat_id, msg.id, user_id)
  end
end
