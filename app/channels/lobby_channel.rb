class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel"
    puts "CLIENT CONNECTED"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "CLIENT DISCONNECTED"
  end

  def test_message(payload)
  end
end
