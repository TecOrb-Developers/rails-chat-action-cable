class ChatSerializer < ApplicationSerializer
  attributes :id, :title, :updated_at, :recent_message
  has_many :users

  def updated_at
    recent_message_at = last_message&.created_at
    recent_message_at.present? ? recent_message_at : object.created_at
  end

  def recent_message
    # ActiveModelSerializers::SerializableResource.new(last_message, serializer: ChatMessageSerializer).as_json
    last_message
  end

  private
  def last_message
    object.chat_messages.available(scope&.id).desc.first
  end
end
