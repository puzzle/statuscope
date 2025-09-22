# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChecksController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    describe 'ok heartbeat' do
      let(:heartbeat) do
        Fabricate(:heartbeat, last_signal_ok: true, interval_seconds: 0)
      end

      it 'returns correct response' do
        get :show, params: { application: heartbeat.application }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['state']).to eq('ok')
      end
    end

    describe 'failing heartbeat' do
      let(:heartbeat) do
        Fabricate(:heartbeat, last_signal_ok: false, interval_seconds: 0)
      end

      it 'returns correct response' do
        get :show, params: { application: heartbeat.application }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['state']).to eq('fail')
      end
    end
  end

  describe 'GET #metrics' do
    let!(:heartbeat) do
      Fabricate(:heartbeat, last_signal_ok: true, interval_seconds: 0)
    end

    context 'with no METRICS_TOKEN configured' do
      around do |example|
        before = ENV.delete('METRICS_TOKEN')
        example.call
      ensure
        ENV['METRICS_TOKEN'] = before if before.present?
      end

      it 'returns prometheus metrics' do
        get :metrics
        expect(response).to have_http_status(:success)
        expect(response.body).to match(/# HELP .*TYPE.*statuscope_check_ok.*/m)
      end
    end

    context 'with a METRICS_TOKEN configured' do
      let(:valid_token) { 'i-am-a-metrics-token-and-i-m-allright' }

      around do |example|
        before = ENV['METRICS_TOKEN']
        ENV['METRICS_TOKEN'] = valid_token
        example.call
      ensure
        ENV.delete('METRICS_TOKEN')
        ENV['METRICS_TOKEN'] = before if before.present?
      end

      it 'with valid bearer token, it returns prometheus metrics' do
        request.headers['Authorization'] = "Bearer #{valid_token}"
        get :metrics
        expect(response).to have_http_status(:success)
        expect(response.body).to match(/# HELP .*TYPE.*statuscope_check_ok.*/m)
      end

      it 'unauthenticated (no token), it returns 401 with empty body' do
        get :metrics
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to be_empty
      end

      it 'unauthorized (wrong token), it returns 403 with empty body' do
        request.headers['Authorization'] = 'Bearer wrong-token'
        get :metrics
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to be_empty
      end

      it 'with malformed header, it returns 401 with empty body' do
        request.headers['Authorization'] = 'Bearer' # No token
        get :metrics
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to be_empty
      end
    end
  end
end
