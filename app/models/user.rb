class User < ApplicationRecord
	has_many :referred_users, :class_name => 'User',:foreign_key => 'referred_user_id',dependent: :nullify
	belongs_to :referred_user, :class_name => 'User',:foreign_key => 'referred_user_id',optional: true
	validates :country_code, presence: true
	validates :mobile_number, presence: true, uniqueness: { scope: :country_code }
	validates_uniqueness_of :email,:allow_blank => false, :allow_nil => false, case_sensitive: false
end
