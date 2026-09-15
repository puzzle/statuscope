# frozen_string_literal: true

# Storage for heartbeating application. This could be a backup or a regular
# deployment that says "I was successful". The Heartbeat stores the last state
# and knows the expected interval. This allows to have "overdue" heartbeats.
class Heartbeat < ApplicationRecord
  has_secure_token

  attribute :interval_seconds, default: -> { 24.hours.to_i }

  validates :interval_seconds, presence: true
  validates :application, presence: true, uniqueness: true

  def self.authenticate!(application:, token:)
    heartbeat = find_by(application: application)

    return heartbeat if heartbeat&.accepts_token?(token)

    raise ActiveRecord::RecordNotFound, "Couldn't find Heartbeat"
  end

  def accepts_token?(candidate)
    return false if candidate.blank? || token.blank?

    ActiveSupport::SecurityUtils.secure_compare(token, candidate) ||
      TeamToken.authenticates?(team, candidate)
  end

  def register(new_state)
    update(
      last_signal_ok: new_state.casecmp('ok').zero?,
      last_signal_at: Time.zone.now
    )
  end

  def as_json(_req = nil)
    {
      application: application,
      team: team,
      state: status,
      last_signal_ok: last_signal_ok?,
      last_signal_recent: last_signal_recent?,
      check_in: last_signal_at,
      interval: interval_seconds
    }
  end

  def status
    return 'fail'     unless last_signal_ok?
    return 'outdated' unless last_signal_recent?

    'ok'
  end

  def ok?
    return false unless last_signal_ok?

    last_signal_recent?
  end

  def last_signal_recent?
    return true if interval_seconds.zero?
    return false if last_signal_at.nil?

    Time.zone.now - interval_seconds < last_signal_at
  end
end
