class SessionsController < ApplicationController
  def create
    puts "LOGGING IN!"
    lobby_code = params[:lobby] || generate_lobby_code
    # lobby should be found or be created if it doesn't exist
    lobby = Lobby.find_by(lobby_code: lobby_code)
    lobby ||= Lobby.create(username: , lobby_code: lobby_code)
    # if lobby does exist already we should check that it isn't full
    if lobby.at_capacity?
      puts "LOBBY IS ALREADY FULL"
    else
      puts "We can fit this new player in!"
    end
    # user should be created everytime they join
    player = Player.create(username: params[:username])
    player.connect_to_lobby(lobby)

    render json: { player_id: player.player_id, user: player.username, lobby: lobby_code }
  end

  private

  def generate_lobby_code
    characters = [('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
    (0...8).map { characters.sample }.join
  end
end
