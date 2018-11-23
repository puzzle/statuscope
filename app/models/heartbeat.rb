# frozen_string_literal: true

# Storage for heartbeating application. This could be a backup or a regular
# deployment that says "I was successful". The Heartbeat store the last state
# and knows the expected interval. This allows to have "overdue" heartbeats.
class Heartbeat < ApplicationRecord
  has_secure_token

  def register(new_state)
    update(
      last_signal_ok: new_state.casecmp('ok').zero?,
      last_signal_at: Time.zone.now
    )
  end
end
