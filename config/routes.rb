Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users

  resources :events do
    resources :registrations
  end

  namespace :admin do
    resources :assignments, :competitions, :users, :sponsorship_types, :sponsors
    resources :regions do
      resources :events, :sponsorships
      resources :assignments, controller: 'regions/assignments'
    end
    resources :events do
      resources :registrations, :event_partners
      resources :assignments, controller: 'events/assignments'
    end
  end

  get 'manage_account', to: 'users#show'
  get 'edit_personal_details', to: 'users#edit'

  root 'competitions#index'
end
