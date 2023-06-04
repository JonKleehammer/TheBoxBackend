class Game < ApplicationRecord
  self.primary_key = :game_id
  has_one :lobby
  has_many :player_to_lobbies, through: :lobby
  has_many :players, through: :player_to_lobbies

  after_create :setup_game

  private

  def setup_game
    set_channel_name
  end

  def set_channel_name
    self.update(channel: "#{game_name}-#{game_id}")
  end
end
