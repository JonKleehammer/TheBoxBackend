class CreateTriviaTussleSchema < ActiveRecord::Migration[7.0]
  def change
    create_schema :trivia_tussle

    create_table :games, id: :serial, primary_key: :game_id do |t|
      t.bigint :lobby_id
      t.string :game_name
      t.string :channel
      t.json :settings
      t.timestamps
    end

    add_foreign_key :games, :lobbies, column: :lobby_id, primary_key: :lobby_id

    create_table 'trivia_tussle.game_states', id: :serial, primary_key: :game_state_id do |t|
      t.bigint :game_id
      t.string :current_stage
      t.boolean :chooser
      t.timestamps
    end

    create_table 'trivia_tussle.player_states', id: :serial, primary_key: :state_id do |t|
      t.bigint :game_id
      t.bigint :player_id
      t.boolean :ready
      t.integer :score
      t.timestamps
    end

    create_table 'trivia_tussle.topics', id: :serial, primary_key: :topic_id do |t|
      t.bigint :player_id, null: false
      t.string :topic
      t.timestamps
    end

    create_table 'trivia_tussle.questions', id: :serial, primary_key: :question_id do |t|
      t.integer :difficulty
      t.string :question
      t.string :answer
      t.boolean :answered, default: false
      t.timestamps
    end

    create_table 'trivia_tussle.question_to_topic', id: :serial, primary_key: :qtt_id do |t|
      t.bigint :topic_id, null: false
      t.bigint :question_id, null: false
      t.timestamps
    end

    add_foreign_key 'trivia_tussle.question_to_topic', 'trivia_tussle.topics', column: :topic_id, primary_key: :topic_id
    add_foreign_key 'trivia_tussle.question_to_topic', 'trivia_tussle.questions', column: :question_id, primary_key: :question_id

  end
end
