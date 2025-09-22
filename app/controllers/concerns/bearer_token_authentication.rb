# frozen_string_literal: true

# Allow for Token-Authentication
module BearerTokenAuthentication
  private

  # the return-value is not really checked, the action halted if a
  # redirect or render happened in the hook. However, the boolean
  # return-value communicates better the "result" and also helps
  # to prevent rubocop from auto-fixing the happy-path into the
  # middle of the method.
  def authenticate_bearer_token
    return true if no_token_set?

    if auth_header.nil? || !auth_header.start_with?('Bearer ')
      render plain: '', status: :unauthorized and return false
    end

    if provided_token != expected_token
      Rails.logger.warn('Invalid bearer token')
      render plain: '', status: :forbidden and return false
    end

    true
  end

  def expected_token_env_var_name
    raise 'Please set #expected_token_env_var_name in your controller when using BearerTokenAuthentication'
  end

  def expected_token
    ENV[expected_token_env_var_name]
  end

  def auth_header
    request.headers['Authorization']
  end

  def provided_token
    auth_header.sub('Bearer ', '').strip
  end

  def no_token_set?
    return true if expected_token.blank?

    Rails.logger.warn("#{expected_token_env_var_name} not set; allowing access")
    false
  end
end
