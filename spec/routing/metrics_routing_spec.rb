# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChecksController, type: :routing do
  describe 'routing' do
    it 'routes to #metrics' do
      expect(get: '/metrics').to route_to('checks#metrics')
    end
  end
end
