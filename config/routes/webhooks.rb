namespace :webhooks do
  namespace :v1 do
    namespace :stripe do
      resources :payments, only: %i[create]
    end
  end
end
