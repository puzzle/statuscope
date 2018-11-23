# frozen_string_literal: true

# Endpoints to get the current state of all Heartbearts
class ChecksController < ApplicationController
  def index
    render json: Heartbeat.all, status: :ok
  end

  def show
    heartbeat = Heartbeat.find_by!(application: params[:application].to_s)
    # :precondition_failed :failed_dependency
    status = heartbeat.last_signal_ok? ? :ok : :not_acceptable
    render json: heartbeat, status: status
  end
end
