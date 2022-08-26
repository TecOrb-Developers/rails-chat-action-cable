class User < ApplicationRecord
	has_secure_password
	has_many :referred_users, :class_name => 'User',:foreign_key => 'referred_user_id',dependent: :nullify
	belongs_to :referred_user, :class_name => 'User',:foreign_key => 'referred_user_id',optional: true
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
end
