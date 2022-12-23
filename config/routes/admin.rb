namespace :admin do
  namespace :v1 do
    resource :health, only: [:show], controller: :health
    resources :product_categories, only: %i[create index]
    resources :product_contents, only: %i[create update], param: :product_id
    resources :products, only: %i[create index show] do
      resources :stocks, only: %i[index create]
    end
  end
end
