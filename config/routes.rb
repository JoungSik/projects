Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  # Authentication routes
  scope controller: :sessions do
    get :login, action: :new
    post :login, action: :create
    delete :logout, action: :destroy
  end

  resources :passwords, param: :token

  resources :users, except: [ :index, :show ]
  resources :user_invitations, except: [ :show, :edit ]

  resources :workspaces, except: :index do
    resources :projects, except: :index do
      resources :tasks, except: :index
    end
  end
end
