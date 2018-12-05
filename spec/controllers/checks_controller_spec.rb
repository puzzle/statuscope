require 'rails_helper'

RSpec.describe ChecksController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:heartbeat) do
      Fabricate(:heartbeat, last_signal_ok: true)
    end

    it "returns http success" do
      get :show, params: { application: heartbeat.application }
      expect(response).to have_http_status(:success)
    end
  end

end
