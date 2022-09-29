class Chats::ConversationsSerializer < ApplicationSerializer
  attributes :id, :title, :updated_at, :recent_message, :members
  # loggedin user can be accessable via scope. Passing scope from conversations list API

  def recent_message
    ActiveModelSerializers::SerializableResource.new(object.recent_message, serializer: Chats::MessagesSerializer, adapter: :attributes).as_json if object.recent_message
  end

  def members
    members_data = object.users.decorate
    ActiveModelSerializers::SerializableResource.new(members_data, each_serializer: Chats::UsersSerializer, adapter: :attributes).as_json
  end

end
