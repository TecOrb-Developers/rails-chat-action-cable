class CableNotifyChatJob < ApplicationJob
  queue_as :default

  def perform(code, chat_id, message_id, sender_id)
    # All Action Cable Codes:
    # 10: New Message,
    # 11: Remove Message,
    # 12: Seen Message,
    # 14: Delivered Message
    # 15: Checkout Payment Link
    # 16: Checkout payment successful
    chat = Chat.find_by_id(chat_id)
    message = chat ? chat.chat_messages.where(id: message_id).first : nil
    sender = User.find_by_id(sender_id)
    if chat and message and sender
      receivers = chat.users.where("users.id != ?", sender.id)
      # Chat Action Cable Codes:
      # 10: New Message,
      # 11: Remove Message,
      # 12: Seen Message,
      # 14: Delivered Message
      result = {
        code: code,
        data: {
          chat: chat.as_json(only: [:id, :title]),
          message: message.as_json({
            only: [:id, :user_id, :content, :doc_url, :doc_type, :deleted, :latitude, :longitude, :created_at],
            methods: [:status]
          }),
          sender: sender.as_json(only: [:id, :fname, :lname, :image, :mobile, :country_code])
        }
      }
      receivers.each do |usr|
        room = "notify_#{usr.id}"
        response = ActionCable.server.broadcast room, result
        # response will return 0 or 1
        # 0 for not delivered 1 for delivered
        if response == 1
          # p "Message delivered"
          if code == 10
            # Sent Message has been delivered to receiver
            dl = message.chat_delivered_messages.where(user_id: usr.id).first_or_create
            dl.update(desc: "ActionCable")
            # p "Notifing sender that message delivered successfully"
            result[:data][:message].merge!(status: 1)
            senderRoom = "notify_#{sender.id}"
            newData = {
              code: 14,
              data: result[:data]
            }
            newResp = ActionCable.server.broadcast senderRoom, newData
            # p "Sender delivery notified"
            # p newResp
          end
        elsif code == 10
          # CablePushMsgJob.perform_async(message.id, usr.id)
          # Message is not delivered, may be user is not connected to action cable
          # so we need to fire notification from push notification
        end
      rescue => e
        response = e
      end
    end
  end
end
