class Api::V1::ChatMessagesController < ApplicationController
	before_action :validate_user_request
  before_action :find_chat

  def create
    # There will be two types of messages
    if params[:message].present?
      # Type 1. Normal Text message
      @msg = @chat.chat_messages.create(content: params[:message], user_id: @user.id)
    elsif params[:doc_type].present? and params[:doc_url].present?
      # Type 2.1. Document Message (doc_type: image, pdf, doc etc)
      # Type 2.2. Location Message (doc_type: location  {with: latitude, longitude})
      @msg = if params[:doc_type] == "location" and params[:latitude].present? and params[:longitude].present?
        @chat.chat_messages.create(doc_type: params[:doc_type], doc_url: params[:doc_url], latitude: params[:latitude], longitude: params[:longitude], user_id: @user.id)
      else
        @chat.chat_messages.create(doc_type: params[:doc_type], doc_url: params[:doc_url], user_id: @user.id)
      end
    end
    if @msg
      data = @msg.as_json(chat_message_json)
      build_response_view("customOk", "Message sent", {message: data})
    else
      build_response_view("not", "Message", {})
    end
  end

  def index
    # Chat's messages list for a User: Chat > messages (instance method)
    # Check Chat Model for more comments
    messages = @chat.messages(@user.id).desc.paginate(page: params[:page], per_page: params[:per_page])
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
    data = messages.as_json(chat_message_json)
    build_response_view("customOk", "Messages", {messages: data})
  end

  def delete
    # Message remove from only loggedin user
    messages = @chat.messages(@user.id).where(id: params[:message_ids])
    messages.each do |msg|
      @user.chat_deleted_messages.where(chat_message_id: msg.id).first_or_create
    end
    build_response_view("customOk", "Messages deleted", {})
  end

  def unsend
    # Message remove from all user's
    messages = @chat.messages(@user.id).where(id: params[:message_ids])
    messages.each do |msg|
      msg.update(deleted: true)
      # code 11 for remove
      # Params for perform_async => (code, chat_id, message_id, sender_id)

      CableNotifyChatWorker.perform_async(11, msg.chat_id, msg.id, msg.user_id)
    end
    build_response_view("customOk", "Messages unsend", {})
  end

  def seen
    @msg = @chat.messages(@user.id).find_by_id(params[:message_id])
    if @msg
      @msg.chat_message_seens.where(user_id: @user.id).first_or_create
      # Action cable broadcast will be send from the ChatMessageSeen Model
      # from after_save callback
      data = @msg.as_json(chat_message_json)
      build_response_view("customOk", "Messages seen", {message: data})
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
      build_response_view("customOk", "Messages delivered", {message: data})
    else
      build_response_view("not", "Message", {})
    end
  end

  private

  def find_chat
    @chat = Chat.all_conversations(@user.id).distinct.find_by_id(params[:chat_id])
    unless @chat
      build_response_view("not", "Chat", {})
    end
  end

  def chat_message_json
    {
      only: [:id, :user_id, :content, :doc_url, :doc_type, :deleted, :latitude, :longitude, :created_at],
      methods: [:status]
    }
  end
end
