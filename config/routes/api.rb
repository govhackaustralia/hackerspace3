namespace :api do
  namespace :v1 do
    get "/health", to: "health#show"

    resources :projects, only: %i[index show]
  end
end
