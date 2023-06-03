class PlayerToLobby < ApplicationRecord
  self.table_name = 'public.player_to_lobby'
  primary_key = :ptl_key
  belongs_to :lobby
  belongs_to :player
end
