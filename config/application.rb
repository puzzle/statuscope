# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'
require 'active_support/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Statuscope
  class Application < Rails::Application # :nodoc:
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.active_support.cache_format_version = 7.0 # silence deprecation warning

    config.generators do |g|
      g.test_framework :rspec

      g.assets false
      g.helpers false
      g.javascripts false
      g.stylesheets false
      g.view_specs false
      g.helper_specs false
    end

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
