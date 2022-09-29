class Api::V1::ChatsController < Api::V1::ApplicationController
	# default :doorkeeper_authorize! is applied to check loggedin user access
	before_action :check_logged_user

  def index
    # Conversation list, check comments in Chat model for more details
    # Below context is used to decorate the active records. We can pass values to decorators via context.
    # Here we are passing loggedin user to query over conversations (to isolate deleted conversations)
    chats = @user.conversations.paginate(page: params[:page], per_page: params[:per_page]).decorate(context: @user.id)
    # Below additional parameter is sending i.e. scope. We can pass values to serializer via scope
    render json: chats, scope: @user, each_serializer: Chats::ConversationsSerializer
  end

  def delete
    Chats::Delete.call(@user, params[:chat_ids])
    render_success
  end

  def removed
    chats = Chat.removed(@user.id).decorate(context: @user.id)
    render json: chats, each_serializer: Chats::ConversationsSerializer
  end
end
