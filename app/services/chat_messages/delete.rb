class ChatMessages::Delete < ApplicationService
  def initialize(chat, deleted_by_user, messages_ids)
    # Deleting message will not delete message from receipients, this will remove message from current user's list
    @chat = chat
    @deleted_by_user = deleted_by_user
    @messages = @chat.messages(deleted_by_user.id).where(id: messages_ids)
  end

  def call
    @messages.each do |msg|
      @deleted_by_user.chat_deleted_messages.where(chat_message_id: msg.id).first_or_create
    end
  end
end
