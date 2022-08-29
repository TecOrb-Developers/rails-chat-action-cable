class Api::V1::ChatsController < Api::V1::ApplicationController
	# default :doorkeeper_authorize! is applied to check loggedin user access
	before_action :check_logged_user

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
    build_response_view("custom_ok", "Conversations list fetched", {chats: data})
  end

  def delete
    chats = @user.conversations.where(id: params[:chat_ids])
    # For help in chat_removes check comments in Chat model
    chats.each do |chat|
      chRemove = @user.chat_removes.where(chat_id: chat.id).first_or_create
      chRemove.update(deleted: true)
      chRemove.chat_remove_logs.create(user_id: @user.id, description: "Chat removed")
    end
    build_response_view("custom_ok", "Conversations deleted", {})
  end

  def removed
    chats = Chat.removed(@user.id)
    data = chats.as_json(only: [:id, :title])
    build_response_view("custom_ok", "Removed conversations list", {chats: data})
  end
end
