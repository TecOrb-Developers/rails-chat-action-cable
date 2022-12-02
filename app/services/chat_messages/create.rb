class ChatMessages::Create < ApplicationService
  def initialize(chat, sender, params)
    @chat = chat
    @sender = sender
    @params = params
    # There will be two types of messages
    # Type 1. Normal Text message
    # Type 2.1. Document Message (doc_type: image, pdf, doc etc)
    # Type 2.2. Location Message (doc_type: location  {with: latitude, longitude})
    @msg = @chat.chat_messages.new({
        user_id: @sender.id,
        content: params[:message],
        doc_type: params[:doc_type],
        doc_url: params[:doc_url],
        latitude: params[:latitude],
        longitude: params[:longitude]
      })
  end

  def call
    { 
      status: @msg.save , 
      data: @msg,
      errors: @msg.errors.full_messages
    }
  end
end
