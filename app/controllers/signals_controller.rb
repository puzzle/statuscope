# frozen_string_literal: true

# Endoint to receive signal from apps
class SignalsController < ApplicationController
  def create
    @heartbeat = Heartbeat.find_by(
      application: params[:application],
      token: params[:token]
    )

    if @heartbeat.register(params[:status])
      render json: @heartbeat, status: :created
    else
      render json: @heartbeat.errors, status: :unprocessable_entity
    end
  end
end
