class LobbyChannel < ApplicationCable::Channel
  before_subscribe :set_params

  def subscribed
    puts "CLIENT CONNECTED TO LOBBY"
    stream_from @channel
    ActionCable.server.broadcast(@channel, "New User Joined: #{params[:player_id]}")
    add_player_to_lobby(@player_id)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "CLIENT DISCONNECTED"
    remove_player_from_lobby(@player_id)
  end

  def load_game(payload)
    @lobby.update(status: 'CLOSED')
    
    ActionCable.server.broadcast(@channel, { action: 'LOAD_GAME', payload: { game_name: payload['game_name'] }})
  end

  private

  def set_params
    @lobby = Lobby.find_or_create_by(lobby_code: :lobby_code, channel: "LobbyChannel-#{params[:lobby_code]}")
    @channel = @lobby.channel
    @player_id = params[:player_id]
  end

  def add_player_to_lobby(player_id)
    @lobby.add_player(player_id)
  end

  def remove_player_from_lobby(player_id)
    @lobby.remove_player(player_id)
  end
end
