# frozen_string_literal: true

# Endoint to receive signals from apps
class SignalsController < ApplicationController
  def create
    @heartbeat = Heartbeat.find_by!(
      application: params.require(:application),
      token: params.require(:token)
    )

    if @heartbeat.register(params.require(:status))
      render json: @heartbeat, status: :created
    else
      render json: @heartbeat.errors, status: :unprocessable_entity
    end
  end
end
