class Chats::Create < ApplicationService
  def initialize(sender, receiver)
    @sender = sender
    @receiver = receiver
  end

  def call
  	@chat = @sender.chat_with(@receiver.id)
    if !@chat
      @chat = @sender.chats.create(title: "single")
      @chat.chat_users.create(user_id: @receiver.id)
    end
    @chat
  end
end
