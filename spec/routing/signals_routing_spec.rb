# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignalsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/signals').to route_to('signals#create')
    end
  end
end
