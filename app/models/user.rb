class User < ApplicationRecord
	has_secure_password
	
	validates :country_code, presence: true
	validates :mobile_number, presence: true, uniqueness: { scope: :country_code }
	validates_uniqueness_of :email,:allow_blank => false, :allow_nil => false, case_sensitive: false

	has_many :access_grants,
				class_name: 'Doorkeeper::AccessGrant',
				foreign_key: :resource_owner_id,
				dependent: :delete_all # or :destroy if you need callbacks
	has_many :access_tokens,
				class_name: 'Doorkeeper::AccessToken',
				foreign_key: :resource_owner_id,
				dependent: :delete_all # or :destroy if you need callbacks

	has_many :referred_users, :class_name => 'User',:foreign_key => 'referred_user_id',dependent: :nullify
	belongs_to :referred_user, :class_name => 'User',:foreign_key => 'referred_user_id',optional: true

	# Chatting Module Associations
	has_many :chats, dependent: :destroy
	has_many :chat_users, dependent: :destroy
	has_many :chat_messages, dependent: :destroy
	has_many :chat_deleted_messages, dependent: :destroy
	has_many :chat_message_seens, dependent: :destroy
	has_many :chat_delivered_messages, dependent: :destroy
	has_many :chat_removes, dependent: :destroy
	has_many :chat_remove_logs, dependent: :destroy

	# When your valdator class is named BlacklistValidator then in your model you use blacklist: true parameter.
	validates :email, blacklist: true, no_yahoo_email: true
	validates :fname, number_not_allowed: true
	validates :lname, number_not_allowed: true

	def conversations
		Chat.conversations(id)
	end

	def chat_with uid
		# After Trip Create we are finding the old conversation between host and guest to initiate chat
		# At Trip after create callback
		cids = Chat.all_conversations(id).pluck("chats.id")
		Chat.joins(:chat_users).where("chats.id IN (?) and chat_users.user_id=?", cids, uid).first
	end

  def unseen_messages
    available_cids = conversations.pluck("chats.id")
    ChatMessage.available(id).where("chat_messages.user_id != ?", id)
      .joins(:chat).where("chats.id IN (?)", available_cids)
      	.where("chat_messages.all_seen=?", false).count
  end
end
