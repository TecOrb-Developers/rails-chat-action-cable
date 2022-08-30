class ChatMessage < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  has_many :chat_message_seens, dependent: :destroy
  has_many :chat_deleted_messages, dependent: :destroy
  has_many :chat_delivered_messages, dependent: :destroy

  scope :desc, -> { order("chat_messages.created_at DESC") }
  scope :asc, -> { order("chat_messages.created_at ASC") }
  # Chat's messages list for a User: Chat > messages (instance method)
  # Check Chat Model for more comments
  scope :available, ->(uid) {
    left_outer_joins(:chat_deleted_messages)
      .where("chat_deleted_messages.id is null or chat_deleted_messages.user_id!=?", uid)
  }

  after_save :set_message

  def set_message
    # Message delivered for sender
    chat_delivered_messages.where(user_id: user_id).first_or_create
    # Message seen for sender
    chat_message_seens.where(user_id: user_id).first_or_create

    cht = chat
    # Touch chat for recent chats sort
    cht.update(last_msg_at: Time.current)
    # Recover receiver's deleted Chat conversations
    cht.update(deleted: false)
    uids = cht.chat_users.pluck(:user_id)
    cht.chat_removes.where(user_id: uids, deleted: true).each do |removed_chat|
      removed_chat.update(deleted: false)
      removed_chat.chat_remove_logs.create(user_id: user_id, category: "recovered", description: "Chat Recovered by new message")
    end

    # Params for perform_now => (code, chat_id, message_id, sender_id)
    CableNotifyChatJob.perform_now(10, chat_id, id, user_id)
  end

  def as_json(options = {})
    if deleted
      options = {
        except: [:content, :doc_type, :doc_url, :updated_at, :chat_id],
        methods: [:status]
      }
      super(options).merge({content: nil, doc_type: nil, doc_url: nil})
    else
      super(options)
    end
  end

  def seen
    # seen, if message's seens exists with other chat members (except sender)
    chat_message_seens.where.not(user_id: user_id).count > 0
  end

  def delivered
    # delivered, if message's deliveries exists with other chat members (except sender)
    chat_delivered_messages.where.not(user_id: user_id).count > 0
  end

  def status
    # Manage status by codes
    if chat_message_seens.where.not(user_id: user_id).count > 0
      2
    elsif chat_delivered_messages.where.not(user_id: user_id).count > 0
      1
    else
      0
    end
  end
end
