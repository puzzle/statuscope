class PrometheusMetrics
  OK = 0
  NOT_OK = 1

  HEADER = <<~END
    # HELP statuscope_check_ok Whether a check is ok (0) or failing (1).
    # TYPE statuscope_check_ok gauge
  END

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
