class ChatMessages::Remove < ApplicationService
  def initialize(chat, deleted_by_user, messages_ids)
    # Remove message will delete message from receipients also
    @chat = chat
    @deleted_by_user = deleted_by_user
    @messages = @chat.messages(deleted_by_user.id).where(id: messages_ids)
  end

  def call
    @messages.each do |msg|
      msg.update(deleted: true)
      # code 11 for remove
      # Params for perform_now => (code, chat_id, message_id, sender_id)
      CableNotifyChatJob.perform_now(11, msg.chat_id, msg.id, msg.user_id)
    end
  end
end
