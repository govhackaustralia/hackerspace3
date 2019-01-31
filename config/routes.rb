Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :data_sets, only: [:index, :show]
  resources :teams, only: [:new, :create]
  resources :favourites, only: [:create, :destroy]
  resources :challenges, param: :identifier, only: [:index, :show]
  resources :users, only: :update

  namespace :users do
    resources :invitations, only: [:update, :destroy]
    resources :memberships, only: [:destroy]
  end

  namespace :flights do
    resources :registrations, only: [] do
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
    resources :sponsors, only: [:show, :edit, :update]
  end

  namespace :admin do
    resources :sponsors
    resources :sponsorship_types, except: [:show, :destroy]
    resources :event_partnerships, only: [:new, :create, :destroy]
    resources :teams, only: [:index, :show, :update]

    resources :competitions, only: [:show, :edit, :update] do
      resources :assignments, only: [:index, :new, :create], controller: 'competitions/assignments'
      resources :scorecards, only: :index, controller: 'competitions/scorecards'
      resources :checkpoints, :criteria, except: [:show, :destroy]
    end

    resources :sponsors do
      resources :sponsorships, only: :destroy, controller: 'sponsors/sponsorships'
      resources :assignments, only: [:new, :create], controller: 'sponsors/assignments'
    end

    resources :regions, except: :destroy do
      resources :data_sets, except: :destroy, controller: 'regions/data_sets'
      resources :assignments, only: [:index, :new, :create], controller: 'regions/assignments'
      resources :sponsorships, only: [:index, :new, :create], controller: 'regions/sponsorships'
      resources :scorecards, only: :index, controller: 'regions/scorecards'
      resources :events, except: :destroy, controller: 'regions/events'
      resources :challenges, except: :destroy, controller: 'regions/challenges'
      resources :bulk_mails, except: :destroy, controller: 'regions/bulk_mails'
    end

    resources :bulk_mails, only: [] do
      resources :correspondences, only: :show, controller: 'bulk_mails/correspondences'
      resources :user_orders, only: :update, controller: 'bulk_mails/user_orders'
    end

    resources :challenges, only: [] do
      resources :challenge_sponsorships, only: [:new, :create, :destroy]
      resources :challenge_data_sets, only: [:new, :create, :destroy], controller: 'challenges/challenge_data_sets'
      resources :assignments, only: [:new, :create], controller: 'challenges/assignments'
      resources :entries, only: [:index, :edit, :update], controller: 'challenges/entries'
    end

    resources :events, only: :index do
      resources :registrations, except: [:show, :destroy]
      resources :event_partnerships, only: [:new, :create, :destroy]
      resources :assignments, only: [:index, :new, :create], controller: 'events/assignments'
      resources :flights, except: :show, controller: 'events/flights'
      resources :bulk_mails, except: :destroy, controller: 'events/bulk_mails'
      resources :group_golden_tickets, only: [:new, :create], controller: 'events/group_golden_tickets'
      resources :staff_flights, only: [:new, :create], controller: 'events/staff_flights'
      resources :individual_goldens, only: [:new, :create], controller: 'events/individual_goldens'
    end

    resources :teams, only: [:index, :show, :update] do
      resources :projects, only: [:index, :show]
      resources :entries, except: [:index, :show], controller: 'teams/entries'
      resources :scorecards, only: [:index, :update, :destroy], controller: 'teams/scorecards'
    end

    resources :users, except: [:destroy, :edit, :update] do
      resources :assignments, only: [:edit, :update, :destroy], controller: 'users/assignments'
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
