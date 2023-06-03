class Player < ApplicationRecord
  self.primary_key = :player_id
  has_one :player_to_lobby
  has_one :lobby, through: :player_to_lobby

  def connect_to_lobby(lobby)
    PlayerToLobby.create(player: self, lobby: lobby)
  end
end
