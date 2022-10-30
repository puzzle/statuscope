# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignalsController, type: :controller do
  let(:app_name) { 'hitobito' }
  let(:app_token) { 'supertoken' }
  let(:heartbeat) do
    Heartbeat.find_by(application: app_name, token: app_token)
  end
  let(:ok_signal) do
    { status: 'ok' }.stringify_keys.merge(valid_session)
  end
  let(:fail_signal) do
    { status: 'fail' }.stringify_keys.merge(valid_session)
  end
  let(:invalid_signal) do
    { status: 'TX' }.stringify_keys.merge(valid_session)
  end
  let(:valid_session) do
    { application: app_name, token: app_token }.stringify_keys
  end

  before :example do
    Fabricate(:heartbeat, application: app_name, token: app_token,
                          last_signal_at: 11.hours.ago, last_signal_ok: false)
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'updates the heartbeat' do
        post :create, params: ok_signal

        expect(heartbeat.last_signal_at).to be_within(1.second).of(Time.zone.now)
        expect(heartbeat.last_signal_ok).to be_truthy
      end

      it 'updates the heartbeat' do
        post :create, params: fail_signal

        expect(heartbeat.last_signal_at).to be_within(1.second).of(Time.zone.now)
        expect(heartbeat.last_signal_ok).to be_falsey
      end

      it 'renders a JSON response with the updated heartbeat' do
        post :create, params: ok_signal
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    xcontext 'with invalid params' do
      it 'renders a JSON response with errors for the signal' do
        post :create, params: invalid_signal
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
