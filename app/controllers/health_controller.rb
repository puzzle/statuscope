# frozen_string_literal: true

# Endpoints to check for application health
class HealthController < ApplicationController
  def index
    render json: { status: :ok }, status: :ok
  end
end
