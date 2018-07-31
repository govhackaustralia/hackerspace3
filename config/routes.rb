Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users

  resources :events do
    resources :registrations
  end

  namespace :admin do
    resources :assignments, :sponsorship_types, :sponsors

    resources :competitions do
      resources :assignments, controller: 'competitions/assignments'
    end
    resources :regions do
      resources :events, :sponsorships
      resources :assignments, controller: 'regions/assignments'
    end
    resources :events do
      resources :registrations, :event_partnerships
      resources :assignments, controller: 'events/assignments'
    end

    resources :users do
      resources :assignments, controller: 'users/assignments'
    end

  end

  get 'manage_account', to: 'users#show'
  get 'edit_personal_details', to: 'users#edit'
  get 'connection_events', to: 'events#index', category_type: STATE_CONNECTIONS

  root 'competitions#index'
end
