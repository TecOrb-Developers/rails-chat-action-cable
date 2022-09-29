class Chats::MessagesSerializer < ApplicationSerializer
  attributes :id, :content, :doc_url, :doc_type, :deleted, :all_seen, :latitude, :longitude, :created_at, :sender

  def sender
    ActiveModelSerializers::SerializableResource.new(object.user.decorate, serializer: Chats::UsersSerializer, adapter: :attributes).as_json
  end
end
