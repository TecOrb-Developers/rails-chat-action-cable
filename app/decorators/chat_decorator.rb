class ChatDecorator < Draper::Decorator
  delegate_all
  # rails generate decorator Chat

  def updated_at
    msg = last_message
    msg ? msg.created_at : created_at
  end

  def recent_message
    last_message
  end

  private

  def last_message
    msg = chat_messages.available(context).desc.first
  end

end
