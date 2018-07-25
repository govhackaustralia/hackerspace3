Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users

  resources :events do
    resources :attendances
  end

  namespace :admin do
    resources :assignments, :competitions, :users
    resources :regions do
      resources :events
    end
    resources :events do
      resources :attendances
    end
  end

  get 'manage_account', to: 'users#show'
  get 'edit_personal_details', to: 'users#edit'

  root 'competitions#index'
end
