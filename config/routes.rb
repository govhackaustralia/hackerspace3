Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :data_sets, only: [:index, :show]
  resources :teams, only: [:new, :create]
  resources :favourites, only: [:create, :destroy]
  resources :challenges, param: :identifier, only: [:index, :show]

  namespace :users do
    resources :invitations, only: [:update, :destroy]
    resources :memberships, only: [:destroy]
  end

  namespace :flights do
    resources :registrations do # FIX: This resource not needed, find alternative. Scope? Namespace?
      resources :registration_flights, only: [:new, :create], controller: 'registrations/registration_flights'
    end
  end

  resources :projects, param: :identifier, only: [:index, :show] do
    resources :scorecards, only: [:new, :edit, :update]
  end

  resources :events, param: :identifier, only: [:index, :show] do
    resources :registrations, except: [:index, :destroy]
    resources :teams, controller: 'events/teams', only: :index
  end

  namespace :team_management do
    resources :teams, only: [:show, :edit, :update] do
      resources :assignments, except: [:show, :edit], controller: 'teams/assignments'
      resources :projects, only: [:create, :edit, :update]
      resources :entries, :team_data_sets, except: :show
    end
  end

  namespace :sponsorship_management do
    resources :sponsors
  end

  namespace :admin do
    resources :assignments, :sponsorship_types, :sponsors, :sponsorships,
      :event_partnerships, :teams

    resources :competitions do
      resources :assignments, controller: 'competitions/assignments'
      resources :scorecards, controller: 'competitions/scorecards'
      resources :checkpoints, :criteria
    end

    resources :sponsors do
      resources :sponsorships, controller: 'sponsors/sponsorships'
      resources :assignments, controller: 'sponsors/assignments'
    end

    resources :regions do
      resources :data_sets, controller: 'regions/data_sets'
      resources :assignments, controller: 'regions/assignments'
      resources :sponsorships, controller: 'regions/sponsorships'
      resources :scorecards, controller: 'regions/scorecards'
      resources :events, controller: 'regions/events'
      resources :challenges, controller: 'regions/challenges'
      resources :bulk_mails, controller: 'regions/bulk_mails'
    end

    resources :bulk_mails do
      resources :correspondences, controller: 'bulk_mails/correspondences'
      resources :user_orders, controller: 'bulk_mails/user_orders'
    end

    resources :challenges do
      resources :challenge_sponsorships, :challenge_data_sets
      resources :assignments, controller: 'challenges/assignments'
      resources :entries, controller: 'challenges/entries'
    end

    resources :events do
      resources :registrations, :event_partnerships
      resources :assignments, controller: 'events/assignments'
      resources :flights, controller: 'events/flights'
      resources :bulk_mails, controller: 'events/bulk_mails'
    end

    resources :teams do
      resources :projects
      resources :entries, controller: 'teams/entries'
      resources :scorecards, controller: 'teams/scorecards'
    end

    resources :users do
      resources :assignments, controller: 'users/assignments'
    end
  end

  get 'stats', to: 'entries#index'
  get 'manage_account', to: 'users#show'
  get 'complete_registration', to: 'users#edit'
  get 'update_personal_details', to: 'users#edit'
  get 'review_terms_and_conditions', to: 'users#edit'
  get 'connections', to: 'events#index', event_type: CONNECTION_EVENT
  get 'competition_events', to: 'events#index', event_type: COMPETITION_EVENT
  get 'awards', to: 'events#index', event_type: AWARD_EVENT
  get 'terms_and_conditions', to: 'static_pages#terms_and_conditions'
  get 'code_of_conduct', to: 'static_pages#code_of_conduct'
  root 'competitions#index'
end
