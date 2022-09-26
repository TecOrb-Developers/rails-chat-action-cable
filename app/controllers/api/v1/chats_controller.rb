class Api::V1::ChatsController < Api::V1::ApplicationController
	# default :doorkeeper_authorize! is applied to check loggedin user access
	before_action :check_logged_user

  def index
    # Conversation list, check comments in Chat model
    chats = @user.conversations.paginate(page: params[:page], per_page: params[:per_page])
    render json: chats, scope: @user, each_serializer: Chats::ConversationsSerializer
  end

  def delete
    Chats::Delete.call(@user, params[:chat_ids])
    render_success
  end

  def removed
    chats = Chat.removed(@user.id)
    render json: chats, scope: @user, each_serializer: Chats::ConversationsSerializer
  end
end
