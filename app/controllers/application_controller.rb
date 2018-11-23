# frozen_string_literal: true

class ApplicationController < ActionController::API # :nodoc:
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: exception.message }, status: :not_found
  end
end
