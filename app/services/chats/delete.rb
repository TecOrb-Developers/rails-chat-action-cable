class Chats::Delete < ApplicationService
  def initialize(deleted_by_user, chats_ids)
    @deleted_by_user = deleted_by_user
    @chats = @deleted_by_user.conversations.where(id: chats_ids)
  end

  def call
  	# For help in chat_removes check comments in Chat model
    @chats.each do |chat|
      remove_log = @deleted_by_user.chat_removes.where(chat_id: chat.id).first_or_create
      remove_log.update(deleted: true)
      remove_log.chat_remove_logs.create(user_id: @deleted_by_user.id, description: "Chat removed")
    end
  end
end
