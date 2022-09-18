class Chat < ApplicationRecord
  belongs_to :user
  has_many :chat_removes, dependent: :destroy
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users
  has_many :chat_messages, dependent: :destroy
  has_many :chat_message_seens, through: :chat_messages
  has_many :chat_deleted_messages, through: :chat_messages
  has_many :chat_delivered_messages, through: :chat_messages

  scope :available, -> { where("chats.deleted =?", false) }
  # User's Conversations will include where
  # 1. User will be in chat's users list
  # 2. User does not has Chat Removes with deleted true for the chat.

  # How Chat Remove works when user will remove a chat:
  # Case 1. A record in chat_removes will create (deleted: true) for the user and chat
  # Case 2. When any new message will come, chat_remove's deleted will be false, now chat will be listed again

  # How Chat messages will be managed with Chat Removes for a User
  # 1. Get last chat_remove_log for removed chat (chat_removes > chat_remove_logs > category: 'removed')
  # 2. List messages which are created after above last chat_remove_log created_at
  # Check the instance method: messages at the bottom

  scope :conversations, ->(uid) {
    removedCids = ChatRemove.where(user_id: uid, deleted: true).pluck(:chat_id).uniq
    all_conversations(uid)
      .available
        .where.not("chats.id": removedCids)
          .distinct
            .order("chats.last_msg_at DESC")
  }

  scope :all_conversations, ->(uid) {
    joins(:chat_users)
      .where("chat_users.user_id=?", uid)
  }

  scope :removed, ->(uid) {
    all_conversations(uid)
      .joins(:chat_removes)
        .distinct
          .order("chats.last_msg_at DESC")
  }

  after_save :add_member

  def add_member
    chat_users.where(user_id: user_id).first_or_create
  end

  def as_json(options = {})
    @loggedin_user = options[:loggedin_user]
    @msg = chat_messages.available(@loggedin_user).desc.first
    super(options)
  end

  def updated_at
    @msg ? @msg.created_at : created_at
  end

  # def recent_message
  #   @msg.as_json({
  #     only: [:id, :content, :docType, :created_at, :user_id, :deleted],
  #     methods: [:seen, :delivered]
  #   })
  # end

  def messages uid
    # Case 1: When Chat is removed by the User
    #   > How Chat messages will be managed with Chat Removes for a User
    #   1. Get last chat_remove_log for removed chat (chat_removes > chat_remove_logs > category: 'removed')
    #   2. List messages which are created after above last chat_remove_log created_at
    # Case 2: When Message is removed by the User
    #   1. A chat_deleted_messages record will be created for the message and user
    #   2. List messages which are not removed by the user
    last_removed = last_removed(uid)
    if last_removed
      chat_messages.available(uid).where("chat_messages.created_at>?", last_removed.created_at)
    else
      chat_messages.available(uid)
    end
  end

  def last_removed uid
    ChatRemoveLog.joins(:chat_remove)
      .where("chat_removes.chat_id=? and chat_remove_logs.category=? and chat_remove_logs.user_id=?", id, "removed", uid)
        .order("chat_remove_logs.created_at DESC").first
  end
end
