# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Heartbeat, type: :model do
  let(:good_heart) do
    Fabricate(:heartbeat, last_signal_ok: true)
  end

  let(:broken_heart) do
    Fabricate(:heartbeat, last_signal_ok: false)
  end

  describe '#register' do
    it 'updates the timestamp for successes' do
      expect do
        good_heart.register('ok')
      end.to change { good_heart.last_signal_at }.to be_within(1.second).of(Time.zone.now)
    end

    it 'updates the timestamp for fails' do
      expect do
        broken_heart.register('fail')
      end.to change { broken_heart.last_signal_at }.to be_within(1.second).of(Time.zone.now)
    end

    it 'allows to register a success' do
      expect do
        broken_heart.register('ok')
      end.to change { broken_heart.last_signal_ok }.to be_truthy
    end

    it 'allows to register a fail' do
      expect do
        good_heart.register('fail')
      end.to change { good_heart.last_signal_ok }.to be_falsy
    end

    it 'records fails for unknown status-codes' do
      expect do
        good_heart.register('flörbel')
      end.to change { good_heart.last_signal_ok }.to be_falsy
    end
  end
end
