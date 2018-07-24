Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users

  namespace :admin do
    resources :assignments
    resources :regions do
      resources :events
    end
  end

  get 'manage_account', to: 'users#show'
  get 'edit_personal_details', to: 'users#edit'
  get 'competition_management', to: 'admin/assignments#index'

  post 'admin/region_assignment', to: 'admin/regions#assignment'

  root 'static_pages#index'
end
