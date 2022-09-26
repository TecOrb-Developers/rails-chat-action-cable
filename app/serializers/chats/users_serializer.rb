class Chats::UsersSerializer < ApplicationSerializer
	attributes :id, :full_name, :contact_number, :joined_at

	def full_name
		object.decorate.full_name
	end

	def joined_at
		object.decorate.joined_at
	end

	def contact_number
		object.decorate.contact_number
	end
end