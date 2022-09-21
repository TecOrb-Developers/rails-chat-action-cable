class Api::V1::ChatsController < Api::V1::ApplicationController
	# default :doorkeeper_authorize! is applied to check loggedin user access
	before_action :check_logged_user

  def index
    # Conversation list, check comments in Chat model
    data = @user.conversations
      .paginate(page: params[:page], per_page: params[:per_page])
				# .as_json({
				# 	only: [:id, :title],
				# 	include: {
				# 		users: {
				# 			only: [:id, :fname, :lname, :mobile_number, :country_code]
				# 		}
				# 	},
				# 	methods: [:updated_at, :recent_message],
				# 	loggedin_user: @user.id
				# })
		# data = ActiveModelSerializers::SerializableResource.new(data, each_serializer: ChatSerializer, scope: @user).as_json
    # build_response_view("custom_ok", "Conversations list fetched", {chats: data})
    # result = { }
    render json: data,scope: @user, status: :ok
  end

  def delete
    Chats::Delete.call(@user, params[:chat_ids])
    build_response_view("custom_ok", "Conversations deleted", {})
  end

  def removed
    chats = Chat.removed(@user.id)
    data = chats.as_json(only: [:id, :title])
    build_response_view("custom_ok", "Removed conversations list", {chats: data})
  end
end
