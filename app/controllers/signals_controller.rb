# frozen_string_literal: true

# Endoint to receive signals from apps
class SignalsController < ApplicationController
  def create
    @heartbeat = Heartbeat.find_by!(
      application: params[:application],
      token: params[:token]
    )

    if @heartbeat.register(params[:status])
      render json: @heartbeat, status: :created
    else
      render json: @heartbeat.errors, status: :unprocessable_entity
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: exception.message }, status: :not_found
  end
end
