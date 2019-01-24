require 'rails_helper'

RSpec.describe ChecksController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    describe 'ok heartbeat' do
      let(:heartbeat) do
        Fabricate(:heartbeat, last_signal_ok: true, interval_seconds: 0)
      end

      it "returns correct response" do
        get :show, params: { application: heartbeat.application }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['state']).to eq('ok')
      end
    end

    describe 'failing heartbeat' do
      let(:heartbeat) do
        Fabricate(:heartbeat, last_signal_ok: false, interval_seconds: 0)
      end

      it "returns correct response" do
        get :show, params: { application: heartbeat.application }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['state']).to eq('fail')
      end
    end

  end

end
