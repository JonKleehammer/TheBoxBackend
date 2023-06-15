class Lobby < ApplicationRecord
  self.primary_key = :lobby_id
  has_many :player_to_lobby
  has_many :players, through: :player_to_lobby

  def self.generate_lobby_code
    characters = [('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
    (0...8).map { characters.sample }.join
  end

  def self.joinable_lobby(lobby_code)
    lobby = find_by(lobby_code: lobby_code)
    lobby.nil? || (lobby.status == 'OPEN' && !lobby.at_capacity?)
  end

  def at_capacity?
    players.count >= max_players
  end

  def add_player(player_id)
    return if status != 'OPEN' # If the lobby isn't OPEN, we should lock the player list
    ActiveRecord::Base.transaction do
      first_player = players.empty?
      new_player = PlayerToLobby.find_or_create_by(lobby_id: lobby_id, player_id: player_id)
      self.update(leader_id: new_player.player_id) if first_player
      broadcast_update_players
    end
  end

  def remove_player(player_id)
    return if status != 'OPEN' # If the lobby isn't OPEN, we should lock the player list
    ActiveRecord::Base.transaction do
      PlayerToLobby.where(lobby_id: lobby_id, player_id: player_id).destroy_all
      new_leader_id = players.first.nil? ? nil : players.first.player_id
      self.update(leader_id: new_leader_id)
      broadcast_update_players
    end
  end

  def get_player_list
    player_list = players.select(:player_id, :username, :ready).as_json
    player_list.each do |player|
      player['leader'] = leader_id == player['player_id']
    end
  end

  def broadcast_update_players
    player_list = get_player_list
    ActionCable.server.broadcast(channel, { action: 'UPDATE_PLAYERS', payload: player_list })
  end
end
