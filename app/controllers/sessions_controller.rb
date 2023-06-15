class SessionsController < ApplicationController
  def create
    puts "LOGGING IN!"
    lobby_code = params[:lobby] || Lobby.generate_lobby_code
    if Lobby.joinable_lobby(lobby_code)
      Lobby.find_or_create_by(lobby_code: lobby_code, channel: "LobbyChannel-#{lobby_code}")
      # user should be created everytime they login
      player = Player.create(username: params[:username])
      render json: { player_id: player.player_id, user: player.username, lobby: lobby_code }
    else
      puts "ERROR, lobby is not joinable"
    end
  end

  private

  def set_params

  end
end
