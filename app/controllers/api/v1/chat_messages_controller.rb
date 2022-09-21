class Api::V1::ChatMessagesController < Api::V1::ApplicationController
  # default :doorkeeper_authorize! is applied to check loggedin user access
  before_action :check_logged_user
  before_action :find_chat

  def create
    @msg = ChatMessages::Create.call(@chat, @user, params)
    if @msg
      data = @msg.as_json(chat_message_json)
      build_response_view("custom_ok", "Message sent", {message: data})
    else
      build_response_view("not", "Message", {})
    end
  end

  def delete
    # Message delete from loggedin user's list only. Receipients will able to see this
    ChatMessages::Delete.call(@chat, @user, params[:message_ids])
    build_response_view("custom_ok", "Messages deleted", {})
  end

  def unsend
    # Message remove from all receipients and loggedin user.
    ChatMessages::Remove.call(@chat, @user, params[:message_ids])
    build_response_view("custom_ok", "Messages unsend", {})
  end

  def index
    # Chat's messages list for a User: Chat > messages (instance method)
    # Check Chat Model for more comments
    @messages = @chat.messages(@user.id).desc.paginate(page: params[:page], per_page: params[:per_page])
    # Seen all old unseed messages because complete chat is seeing now
    unseen = @chat.chat_messages.left_outer_joins(:chat_message_seens).where("chat_message_seens.id is null or (chat_message_seens.user_id != ?)", @user.id).pluck("chat_messages.id").uniq
    unseen.each do |mid|
      @user.chat_message_seens.where(chat_message_id: mid).first_or_create
    end
    # Deliver all old undelivered messages, all saved messages are listed through the API
    undelivered = @chat.chat_messages.left_outer_joins(:chat_delivered_messages).where("chat_delivered_messages.id is null or (chat_delivered_messages.user_id != ?)", @user.id).pluck("chat_messages.id").uniq
    undelivered.each do |mid|
      @user.chat_delivered_messages.where(chat_message_id: mid).first_or_create
    end
    render json: @messages, each_serializer: ChatMessageSerializer, exclude: [:user_id]
  end

  def seen
    @msg = @chat.messages(@user.id).find_by_id(params[:message_id])
    if @msg
      @msg.chat_message_seens.where(user_id: @user.id).first_or_create
      # Action cable broadcast will be send from the ChatMessageSeen Model
      # from after_save callback
      data = @msg.as_json(chat_message_json)
      build_response_view("custom_ok", "Messages seen", {message: data})
    else
      build_response_view("not", "Message", {})
    end
  end

  def deliver
    # No need for this API, as we are tracking delivery status by Action Cable
    @msg = @chat.messages(@user.id).find_by_id(params[:message_id])
    if @msg
      @msg.chat_delivered_messages.where(user_id: @user.id).first_or_create
      data = @msg.as_json(chat_message_json)
      build_response_view("custom_ok", "Messages delivered", {message: data})
    else
      build_response_view("not", "Message", {})
    end
  end

  private

  def find_chat
    @chat = Chat.all_conversations(@user.id).distinct.find_by_id(params[:chat_id])
    if !@chat
      receiver = User.find_by_id(params[:receiver_id])
      if receiver
        @chat = Chats::Create.call(@user, receiver)
      else
        build_response_view("not", "Receiver", {})
      end
    end
  end

  def chat_message_json
    {
      only: [:id, :user_id, :content, :doc_url, :doc_type, :deleted, :latitude, :longitude, :created_at],
      methods: [:status]
    }
  end
end
