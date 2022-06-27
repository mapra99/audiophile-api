Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    namespace :v1 do
      resource :health, only: [:show], controller: :health
      resources :products, only: %i[create index show]
      resources :product_categories, only: %i[create index]
      resources :product_contents, only: %i[create]
    end
  end

  namespace :api do
    namespace :v1 do
      resource :health, only: [:show], controller: :health
    end
  end
end
