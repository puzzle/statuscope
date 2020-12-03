# frozen_string_literal: true

class AddTeamToHeartbeats < ActiveRecord::Migration[5.2]
  def change
    add_column :heartbeats, :team, :string
  end
end
