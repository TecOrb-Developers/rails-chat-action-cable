# app/channels/chat_channel.rb
class NotifyChannel < ApplicationCable::Channel
  # ApplicationCable::Channel will work as Parent Cable Class like ApplicationController
  before_subscribe :verify_subscriber

  def subscribed
    # Called when the consumer has successfully become a subscriber to this channel.
    # p "---------- subscribed #{params.inspect}"
    if @validRoom==@requestRoom
      stream_from @validRoom
    else
      reject
    end
  end

  def unsubscribed
    # p "xxxxxxxxxxxxxxxx unsubscribed #{params.inspect}"
  end

  def receive(data)
    # Here, data will be receive from Client when 
    # Client will send data on this channel
    # now below rebroadcast the message on the channel
    # p "valid room"
    # p @validRoom
    # p @requestRoom
    # msg = {
    #   msg: "Sending testing message in reply",
    #   room: @validRoom
    # }

    # ActionCable.server.broadcast @validRoom, {
    #   message: msg
    # }
  end

  def verify_subscriber
    # from payload
    @validRoom = "notify_#{user["id"]}"
    @requestRoom = "notify_#{params[:room_id]}"
  end
end