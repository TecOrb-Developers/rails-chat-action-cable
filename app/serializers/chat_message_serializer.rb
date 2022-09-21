class ChatMessageSerializer < ApplicationSerializer
  belongs_to :chat
  attributes :id, :user_id, :content, :doc_url, :doc_type, :deleted, :latitude, :longitude, :created_at, :seen#, :delivered

  # def seen
  #   # seen, if message's seens exists with other chat members (except sender)
  #   object.chat_message_seens.where.not(user_id: object.user_id).count > 0
  # end

  # def delivered
  #   # delivered, if message's deliveries exists with other chat members (except sender)
  #   chat_delivered_messages.where.not(user_id: object.user_id).count > 0
  # end
end

