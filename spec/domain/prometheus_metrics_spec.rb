# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrometheusMetrics, type: :model do
  let(:good_heart) do
    Fabricate(:heartbeat, application: 'good_app', last_signal_ok: true)
  end

  let(:broken_heart) do
    Fabricate(:heartbeat, application: 'bad_app', last_signal_ok: false)
  end

  it '.render' do
    lines =
      PrometheusMetrics.render([good_heart, broken_heart]).split("\n")

    expect(lines.count).to eq(4)

    header_1, header_2, good_line, bad_line = lines

    expect(header_1).to eq(
      '# HELP statuscope_check_ok Whether a check is ok (0) or failing (1).'
    )
    expect(header_2).to eq('# TYPE statuscope_check_ok gauge')

    expect(good_line).to match(
      /statuscope_check_ok{application="good_app"} 0 \d+$/
    )
    expect(bad_line).to match(
      /statuscope_check_ok{application="bad_app"} 1 \d+$/
    )
  end
end
