class SessionsController < ApplicationController
  def create
    puts "LOGGING IN!"
    username = params[:username]
    lobby = params[:lobby] || generate_lobby_code

    guid = SecureRandom.uuid
    session[:guid] = guid

    render json: { user_id: guid, user: username, lobby: lobby}
  end

  private

  def generate_lobby_code
    characters = [('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
    (0...8).map { characters.sample }.join
  end
end
