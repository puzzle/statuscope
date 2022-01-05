# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrometheusMetrics, type: :model do
  let(:good_heart) do
    Fabricate(:heartbeat, application: 'good_app', last_signal_ok: true, team: 'puzzle')
  end

  let(:broken_heart) do
    Fabricate(:heartbeat, application: 'bad_app', last_signal_ok: false, team: 'careless')
  end

  it '.render' do
    lines = PrometheusMetrics.render([good_heart, broken_heart]).split("\n")

    expect(lines.count).to eq(4)

    hdr_help, hdr_type, good_line, bad_line = lines

    expect(hdr_help).to eq('# HELP statuscope_check_ok Whether a check is ok (1) or failing (2).')
    expect(hdr_type).to eq('# TYPE statuscope_check_ok gauge')

    expect(good_line).to match(/statuscope_check_ok{application="good_app",team="puzzle"} 1 \d+$/)
    expect(bad_line).to match(/statuscope_check_ok{application="bad_app",team="careless"} 2 \d+$/)
  end
end
