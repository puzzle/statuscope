# frozen_string_literal: true

# Endpoints to get the current state of all Heartbearts
class ChecksController < ApplicationController
  include BearerTokenAuthentication # provides authenticate_bearer_token
  before_action :authenticate_bearer_token, only: :metrics

  def index
    render json: Heartbeat.all, status: :ok
  end

  def show
    heartbeat = Heartbeat.find_by!(application: params[:application].to_s)
    render json: heartbeat
  end

  def metrics
    render plain: PrometheusMetrics.render(Heartbeat.all)
  end

  private

  def expected_token_env_var_name = 'METRICS_TOKEN'
end
