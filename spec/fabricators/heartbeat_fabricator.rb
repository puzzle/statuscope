# frozen_string_literal: true

Fabricator(:heartbeat) do
  application      'hitobito'
  # token            SecureRandom::base58
  interval_seconds 12.hours.to_i
  last_signal_at   1.hour.ago
  last_signal_ok   true
end
