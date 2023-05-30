class LobbyChannel < ApplicationCable::Channel
  def subscribed
    puts "CLIENT CONNECTED"
    @lobby_id = "LobbyChannel-#{params[:lobby_code]}"
    stream_from @lobby_id

    ActionCable.server.broadcast(@lobby_id, "New User Joined: #{params[:user_id]}")
    user_date = params.slice(:user_id, :username).to_h
    add_user_to_lobby(user_date)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "CLIENT DISCONNECTED"
    remove_user_from_lobby(params[:user_id])
  end

  def load_game(payload)
    ActionCable.server.broadcast(@lobby_id, { action: 'LOAD_GAME', payload: { game_name: payload['route_name'] }})
  end

  private

  def lobby_users
    @@lobby_users ||= {}
  end

  def add_user_to_lobby(new_user)
    puts "ADD #{new_user} to lobby"
    lobby_users[@lobby_id] ||= []
    if lobby_users[@lobby_id].none? { |user| user['user_id'] == new_user['user_id'] }
      lobby_users[@lobby_id] << new_user
      broadcast_player_list
    end
  end

  def remove_user_from_lobby(user_id)
    lobby_users[@lobby_id].reject! { |user| user['user_id'] === user_id } if lobby_users[@lobby_id]
    broadcast_player_list
  end

  def broadcast_player_list
    players = lobby_users[@lobby_id] || []
    ActionCable.server.broadcast(@lobby_id, { action: 'UPDATE_PLAYERS', payload: players })
  end
end
