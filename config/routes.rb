# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  post 'signal', to: 'signals#create', as: 'signal'

  get 'checks/', to: 'checks#index', as: 'checks'
  get 'checks/:application', to: 'checks#show', as: 'check'

  get 'healthz', to: 'health#index', as: 'healthz'
end
