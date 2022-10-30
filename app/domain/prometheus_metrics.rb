# frozen_string_literal: true

# Display current heartbeat-states in prometheus format
class PrometheusMetrics
  OK = 1
  FAILED = 2
  OUTDATED = 3

  HEADER = <<~TEXT
    # HELP statuscope_check_ok Whether a check is ok (1), failing (2) or outdated (3).
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
      value = case heartbeat.status
              when 'ok' then OK
              when 'fail' then FAILED
              when 'outdated' then OUTDATED
              else
                FAILED
              end

      app = heartbeat.application
      team = heartbeat.team

      %(statuscope_check_ok{application="#{app}",team="#{team}"} #{value} #{timestamp})
    end
  end
end
