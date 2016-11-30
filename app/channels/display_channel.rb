# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class DisplayChannel < ApplicationCable::Channel
  def subscribed
    stream_from "display_channel" # was "clock_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
