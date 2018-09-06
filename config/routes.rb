Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users do
    resources :assignments, controller: 'users/assignments'
  end

  resources :data_sets, :teams, :peoples_scorecards, :favourites, :entries

  resources :projects, param: :identifier

  resources :events, param: :identifier do
    resources :registrations
    resources :teams, controller: 'events/teams'
  end

  resources :challenges do
    resources :entries
  end

  namespace :team_management do
    resources :teams do
      resources :assignments, controller: 'teams/assignments'
      resources :projects, :team_data_sets, :entries
    end
  end

  namespace :sponsorship_management do
    resources :sponsors
  end

  namespace :admin do
    resources :assignments, :sponsorship_types, :sponsors, :sponsorships,
      :event_partnerships, :challenge_scorecards, :teams

    resources :competitions do
      resources :assignments, controller: 'competitions/assignments'
      resources :checkpoints, :criteria, :peoples_scorecards
    end

    resources :sponsors do
      resources :sponsorships, controller: 'sponsors/sponsorships'
      resources :assignments, controller: 'sponsors/assignments'
    end

    resources :regions do
      resources :events, :challenges, :data_sets
      resources :assignments, controller: 'regions/assignments'
      resources :sponsorships, controller: 'regions/sponsorships'
    end

    resources :challenges do
      resources :assignments, controller: 'challenges/assignments'
      resources :challenge_criteria, :entries, :challenge_sponsorships, :challenge_data_sets
    end

    resources :events do
      resources :registrations, :event_partnerships
      resources :assignments, controller: 'events/assignments'
    end

    resources :teams do
      resources :entries, :projects
      resources :entries, controller: 'teams/entries'
    end

    resources :users do
      resources :assignments, controller: 'users/assignments'
    end
  end

  get 'manage_account', to: 'users#show'

  get 'complete_registration', to: 'users#edit'

  get 'update_personal_details', to: 'users#edit'

  get 'terms_and_conditions', to: 'users#edit'

  get 'connections', to: 'events#index', event_type: CONNECTION_EVENT

  get 'competition_events', to: 'events#index', event_type: COMPETITION_EVENT

  root 'competitions#index'
end
