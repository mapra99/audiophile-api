require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  draw(:sidekiq)
  draw(:admin)
  draw(:api)
  draw(:webhooks)

  resource :health, only: [:show], controller: :health
end
