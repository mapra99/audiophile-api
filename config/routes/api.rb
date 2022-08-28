namespace :api do
  namespace :v1 do
    resource :health, only: [:show], controller: :health
    resources :product_categories, only: %i[index show], param: :slug
    resources :products, only: %i[index show], param: :slug do
      resources :stocks, only: %i[index], param: :uuid
    end
    resources :purchase_carts, only: %i[index create destroy show], param: :uuid do
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
