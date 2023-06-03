class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :lobbies, id: :serial, primary_key: :lobby_id do |t|
      t.string :lobby_code
      t.string :status, default: 'OPEN'
      t.integer :max_players, default: 10
      t.timestamps
    end

    create_table :players,  id: :serial, primary_key: :player_id do |t|
      t.string :username
      t.timestamps
    end

    create_table :player_to_lobby, id: :serial, primary_key: :ptl_key do |t|
      t.bigint :lobby_id, null: false
      t.bigint :player_id, null: false
      t.timestamps
    end

    add_foreign_key :player_to_lobby, :lobbies, primary_key: :lobby_id
    add_foreign_key :player_to_lobby, :players, primary_key: :player_id
  end
end
