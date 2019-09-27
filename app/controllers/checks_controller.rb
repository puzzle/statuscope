# frozen_string_literal: true

# Endpoints to get the current state of all Heartbearts
class ChecksController < ApplicationController
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
end
