# frozen_string_literal: true

class CreateTeamTokens < ActiveRecord::Migration[7.1] # :nodoc:
  def change
    create_table :team_tokens do |t|
      t.string :team, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_index :team_tokens, :team, unique: true
    add_index :team_tokens, :token, unique: true
  end
end
