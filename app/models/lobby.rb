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
    ActiveRecord::Base.transaction do
      first_player = players.empty?
      PlayerToLobby.find_or_create_by(lobby_id: lobby_id, player_id: player_id, leader: first_player)
      broadcast_update_players
    end
  end

  def remove_player(player_id)
    ActiveRecord::Base.transaction do
      PlayerToLobby.where(lobby_id: lobby_id, player_id: player_id).destroy_all
      player_to_lobby.each_with_index { |ptl, index| ptl.update(leader: index.zero?) }
      broadcast_update_players
    end
  end

  def get_player_list
    players.select(:player_id, :username, :leader, :ready).as_json
  end

  def broadcast_update_players
    player_list = get_player_list
    ActionCable.server.broadcast(channel, { action: 'UPDATE_PLAYERS', payload: player_list })
  end
end
