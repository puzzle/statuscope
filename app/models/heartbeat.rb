# frozen_string_literal: true

# Storage for heartbeating application. This could be a backup or a regular
# deployment that says "I was successful". The Heartbeat stores the last state
# and knows the expected interval. This allows to have "overdue" heartbeats.
class Heartbeat < ApplicationRecord
  has_secure_token

  attribute :interval_seconds, default: -> { 24.hours.to_i }

  validates :interval_seconds, presence: true
  validates :application, presence: true, uniqueness: true

  def register(new_state)
    update(
      last_signal_ok: new_state.casecmp('ok').zero?,
      last_signal_at: Time.zone.now
    )
  end

  def as_json(req)
    {
      application: application,
      state: last_signal_ok? ? 'ok' : 'fail',
      check_in: last_signal_at,
      interval: interval_seconds
    }
  end
end
