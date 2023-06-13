Rails.application.routes.draw do
  if Rails.env.in? %w[development staging]
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  resources :resources, only: :index do
    collection do
      get :data_portals
      get :tech
    end
  end
  resources :data_sets, only: [:index, :show]
  resources :teams, only: [:new, :create]
  resources :favourites, only: [:create, :destroy]
  resources :regions, only: :show
  resources :challenges, param: :identifier, only: [:index, :show] do
    collection do
      get 'landing_page'
      get 'table'
    end
    member do
      get 'entries'
      get 'entries_table'
    end
  end
  resources :visits, only: :index

  resources :users, only: :update
  resources :accounts, only: [:edit, :update]
  resources :agreements, only: [:edit, :update]
  resources :demographics, only: [:edit, :update]
  resources :connections, :conference, :competition_events, :awards, only: :index
  resources :hunt_questions, only: [:index, :update]

  namespace :users do
    resources :invitations, only: [:update, :destroy]
    resources :memberships, only: [:destroy]
  end

  resources :profiles, only: [:index, :show, :edit, :update]
  resources :profile_pictures, only: [:edit, :update]
  resources :badges, only: [] do
    resources :claims, only: [:new, :create]
  end

  resources :projects, param: :identifier, only: [:index, :show] do
    member do
      post :slack_chat
    end
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
      resources :resources, except: :show
      resources :visits, only: :index
      resources :badges do
        member { post :award }
      end
      resources :hunt_questions, only: [:index, :new, :create, :edit, :update] do
        collection do
          patch :badge
          patch :hunt_published
        end
      end
      member do
        get 'aws_credits_requested'
        get 'sponsor_data_set_report'
        get 'demographics_report'
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
        member do
          get :preview
          get :edit_banner_image
          patch :update_banner_image
        end
      end
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
    end

    resources :teams, only: [] do
      resources :projects, only: [:index, :show, :edit, :update]
      resources :entries, except: [:index, :show], controller: 'teams/entries'
      resources :scorecards, only: [:index, :update, :destroy], controller: 'teams/scorecards'
    end

    resources :profiles, only: :update

    resources :users, only: [:index, :show, :destroy] do
      member do
        post :confirm
        patch :act_on_behalf_of_user
        patch :cease_acting_on_behalf_of_user
      end
      collection do
        get 'mailing_list_export'
      end
      resources :assignments, only: :destroy, controller: 'users/assignments'
    end
  end

  get 'manage_account', to: 'users#show'
  get 'review_terms_and_conditions', to: 'agreements#edit'
  get 'complete_registration', to: 'accounts#edit'
  get 'demographics', to: 'demographics#edit'
  get 'update_personal_details', to: 'users#edit'
  get 'update_profile_picture', to: 'profile_pictures#edit'
  get 'terms_and_conditions', to: 'static_pages#terms_and_conditions'
  get 'treasure_hunt', to: 'hunt_questions#index'

  mount ActionCable.server => '/cable'

  root 'competitions#show'

  draw(:api)
end
