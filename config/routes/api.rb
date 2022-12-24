namespace :api do
  namespace :v1 do
    resource :health, only: [:show], controller: :health
    resources :product_categories, only: %i[index show], param: :slug
    resources :products, only: %i[index show], param: :slug do
      resources :stocks, only: %i[index], param: :uuid
    end
    resources :purchase_carts, only: %i[index create destroy show update], param: :uuid do
      resources :cart_items, only: %i[create destroy], param: :uuid
    end
    namespace :auth do
      post 'signup'
      post 'login'
      post 'confirmation'
      post 'logout'
    end
    resources :sessions, only: %i[create], param: :uuid
    resources :locations, only: %i[create index]
    resources :payments, only: %i[create index]
    resources :page_views, only: %i[create]
  end
end
