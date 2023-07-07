namespace :api do
  namespace :v1 do
    get "/health", to: "health#show"

    resources :events, only: %i[index show]
    resources :projects, only: %i[index show]
  end
end
