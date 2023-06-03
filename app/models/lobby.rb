class Lobby < ApplicationRecord
  self.primary_key = :lobby_id
  has_many :player_to_lobby
  has_many :players, through: :player_to_lobby

  def at_capacity?
    players.count >= max_players
  end
end
