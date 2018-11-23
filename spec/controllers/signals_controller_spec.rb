# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignalsController, type: :controller do # rubocop:disable Metrics/BlockLength,Metrics/LineLength
  let(:app_name) { 'hitobito' }
  let(:app_token) { 'supertoken' }
  let(:heartbeat) do
    Heartbeat.find_by(application: app_name, token: app_token)
  end
  let(:valid_attributes) do
    { status: 'ok' }.stringify_keys.merge(valid_session)
  end
  let(:invalid_attributes) do
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
        expect do
          post :create, params: valid_attributes
        end.to change(heartbeat, :last_signal_at)
          .and change(heartbeat, :last_signal_ok)

        expect(heartbeat.last_signal_at).to be > 1.second.ago
        expect(heartbeat.last_signal_ok).to be_truthy
      end

      it 'renders a JSON response with the updated heartbeat' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the signal' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
