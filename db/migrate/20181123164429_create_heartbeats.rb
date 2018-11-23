# frozen_string_literal: true

class CreateHeartbeats < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    create_table :heartbeats do |t|
      t.string :application
      t.string :token
      t.integer :interval_seconds
      t.datetime :last_signal_at
      t.boolean :last_signal_ok

      t.timestamps
    end
    add_index :heartbeats, :token, unique: true
    add_index :heartbeats, :application, unique: true
  end
end
