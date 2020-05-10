Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :data_sets, only: [:index, :show] do
    collection { get :highlight }
  end
  resources :teams, only: [:new, :create]
  resources :favourites, only: [:create, :destroy]
  resources :challenges, param: :identifier, only: [:index, :show] do
    collection do
      get 'landing_page'
      get 'table'
    end
    member { get 'entries' }
  end
  resources :users, only: :update do
    collection do
      patch :accept_terms_and_conditions, :complete_registration_update
    end
  end
  resources :connections, :competition_events, :awards, only: :index

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
    resources :registrations, except: [:index, :destroy] do
      collection { get 'limit_reached' }
    end
    resources :teams, controller: 'events/teams', only: :index
  end

  namespace :team_management do
    resources :teams, only: [:show, :edit, :update] do
      member do
        get :edit_thumbnail, :edit_image
        patch :update_thumbnail, :update_image
      end
      resources :assignments, except: [:show, :edit], controller: 'teams/assignments'
      resources :projects, only: [:create, :edit, :update]
      resources :entries, :team_data_sets, except: :show
    end
  end

  namespace :sponsorship_management do
    resources :sponsors, only: [:show, :edit, :update]
  end

  namespace :admin do
    resources :sponsor_logos, only: [:edit, :update]
    resources :event_partnerships, only: [:new, :create, :destroy]

    resources :competitions, except: :destroy do
      resources :assignments, only: [:index, :new, :create], controller: 'competitions/assignments'
      resources :scorecards, only: :index, controller: 'competitions/scorecards'
      resources :checkpoints, :criteria, :sponsorship_types, except: [:show, :destroy]
      resources :regions, except: :destroy
      resources :teams, only: [:index, :show] do
        member { patch :update_version, :update_published }
        resources :scorecards, only: [:index, :update, :destroy], controller: 'teams/scorecards'
      end
      resources :events, only: :index
      resources :sponsors
      member do
        get 'aws_credits_requested'
        get 'sponsor_data_set_report'
      end
    end

    resources :checkpoints, only: [] do
      resources :region_limits, except: [:show, :index, :destroy]
    end

    resources :sponsors, only: [] do
      resources :sponsorships, only: :destroy, controller: 'sponsors/sponsorships'
      resources :assignments, only: [:new, :create], controller: 'sponsors/assignments'
    end

    resources :regions, only: [] do
      resources :data_sets, except: [:show, :destroy], controller: 'regions/data_sets'
      resources :assignments, only: [:index, :new, :create], controller: 'regions/assignments'
      resources :sponsorships, only: [:index, :new, :create], controller: 'regions/sponsorships'
      resources :scorecards, only: :index, controller: 'regions/scorecards'
      resources :events, except: :destroy, controller: 'regions/events' do
        member { get :preview }
      end
      resources :challenges, except: :destroy, controller: 'regions/challenges' do
        member { get :preview }
      end
      resources :bulk_mails, except: :destroy, controller: 'regions/bulk_mails'
    end

    resources :bulk_mails, only: [] do
      resources :correspondences, only: :show, controller: 'bulk_mails/correspondences'
      resources :user_orders, only: :update, controller: 'bulk_mails/user_orders'
    end

    resources :challenges, only: [] do
      resources :challenge_sponsorships, only: [:new, :create, :destroy]
      resources :challenge_data_sets, only: [:new, :create, :destroy], controller: 'challenges/challenge_data_sets'
      resources :judges, only: [:new, :create], controller: 'challenges/judges'
      resources :entries, only: [:index, :edit, :update], controller: 'challenges/entries'
    end

    resources :events, only: [] do
      resources :registrations, except: [:show, :destroy]
      resources :event_partnerships, only: [:new, :create, :destroy]
      resources :assignments, only: [:index, :new, :create], controller: 'events/assignments'
      resources :flights, except: :show, controller: 'events/flights'
      resources :bulk_mails, except: :destroy, controller: 'events/bulk_mails'
      resources :group_goldens, only: [:new, :create], controller: 'events/group_goldens'
      resources :staff_flights, only: [:new, :create], controller: 'events/staff_flights'
      resources :individual_goldens, only: [:new, :create], controller: 'events/individual_goldens'
    end

    resources :teams, only: [] do
      resources :projects, only: [:index, :show, :edit, :update]
      resources :entries, except: [:index, :show], controller: 'teams/entries'
      resources :scorecards, only: [:index, :update, :destroy], controller: 'teams/scorecards'
    end

    resources :users, only: [:index, :show] do
      member { post 'confirm' }
      collection do
        get 'mailing_list_export'
      end
      resources :assignments, only: :destroy, controller: 'users/assignments'
    end
  end

  # get 'stats', to: 'entries#index'
  get 'manage_account', to: 'users#show'
  get 'complete_registration', to: 'users#complete_registration_edit'
  get 'update_personal_details', to: 'users#edit'
  get 'review_terms_and_conditions', to: 'users#review_terms_and_conditions'
  get 'terms_and_conditions', to: 'static_pages#terms_and_conditions'
  get 'code_of_conduct', to: 'static_pages#code_of_conduct'

  mount ActionCable.server => '/cable'

  root 'competitions#show'
end
