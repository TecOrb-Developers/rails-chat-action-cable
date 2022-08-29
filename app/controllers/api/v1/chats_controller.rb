class Api::V1::ChatsController < ApplicationController
	before_action :validate_user_request

  def index
    # Conversation list, check comments in Chat model
    data = @user.conversations
      .paginate(page: params[:page], per_page: params[:per_page])
				.as_json({
					only: [:id, :title],
					include: {
						users: {
							only: [:id, :fname, :lname, :mobile_number, :country_code]
						}
					},
					methods: [:updated_at, :recent_message],
					loggedin_user: @user.id
				})
    sendResponse("customOk", "Conversations list fetched", {chats: data})
  end

  def delete
    chats = @user.conversations.where(id: params[:chat_ids])
    # For help in chat_removes check comments in Chat model
    chats.each do |chat|
      chRemove = @user.chat_removes.where(chat_id: chat.id).first_or_create
      chRemove.update(deleted: true)
      chRemove.chat_remove_logs.create(user_id: @user.id, description: "Chat removed")
    end
    sendResponse("customOk", "Conversations deleted", {})
  end

  def removed
    chats = Chat.removed(@user.id)
    data = chats.as_json(only: [:id, :title])
    sendResponse("customOk", "Removed conversations list", {chats: data})
  end
end