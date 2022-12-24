namespace :admin do
  namespace :v1 do
    resource :health, only: [:show], controller: :health
    resources :product_categories, only: %i[create index update]
    resources :product_contents, only: %i[create]
    resources :products, only: %i[create index show update] do
      resources :stocks, only: %i[index create]
    end
  end
end
