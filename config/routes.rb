require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/eng/sidekiq'

  namespace :admin do
    namespace :v1 do
      resource :health, only: [:show], controller: :health
      resources :product_categories, only: %i[create index]
      resources :product_contents, only: %i[create]
      resources :products, only: %i[create index show] do
        resources :stocks, only: %i[index create]
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resource :health, only: [:show], controller: :health
      resources :product_categories, only: %i[index show], param: :slug
      resources :products, only: %i[index show], param: :slug do
        resources :stocks, only: %i[index], param: :uuid
      end
      resources :purchase_carts, only: %i[create destroy show], param: :uuid do
        resources :cart_items, only: %i[create destroy], param: :uuid
      end
      namespace :auth do
        post 'signup'
        post 'login'
        post 'confirmation'
        post 'logout'
      end
      resources :sessions, only: %i[create], param: :uuid
    end
  end
end
