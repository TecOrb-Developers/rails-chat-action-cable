# app/channels/chat_channel.rb
class NotifyChannel < ApplicationCable::Channel
  # ApplicationCable::Channel will work as Parent Cable Class like ApplicationController
  before_subscribe :callback_for_before_subscribe_channel

  def subscribed
    # Called when the consumer has successfully become a subscriber to this channel.
    stream_from current_user_room
  end

  def unsubscribed
    # p "xxxxxxxxxxxxxxxx unsubscribed #{params.inspect}"
  end

  def receive(data)
    # When client will broadcast something on this channel, request will receive here
    # From here we will broadcast client's message to all subscribers, below we are 
    # rebroadcasting the message (received from client) on the channel
    msg = {
      msg: data
    }

    ActionCable.server.broadcast current_user_room, {
      message: msg
    }
  end

  def callback_for_before_subscribe_channel
    # reject unless current_user
  end

  def current_user_room
    "notify_#{current_user["id"]}"
  end
end