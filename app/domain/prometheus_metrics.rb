# frozen_string_literal: true

# Display current heartbeat-states in prometheus format
class PrometheusMetrics
  OK = 1
  NOT_OK = 2

  HEADER = <<~TEXT
    # HELP statuscope_check_ok Whether a check is ok (1) or failing (2).
    # TYPE statuscope_check_ok gauge
  TEXT

  class << self
    def render(heartbeats)
      timestamp_ms = (Time.now.to_f * 1_000).to_i

      HEADER +
        heartbeats.map do |heartbeat|
          render_metric(heartbeat, timestamp_ms)
        end.join("\n")
    end

    private

    def render_metric(heartbeat, timestamp)
      value = heartbeat.ok? ? OK : NOT_OK
      app = heartbeat.application
      "statuscope_check_ok{application=\"#{app}\"} #{value} #{timestamp}"
    end
  end
end
