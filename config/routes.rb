Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "studios#index" # トップページ

  resources :users, only: [ :new, :create ]
  # ログイン・ログアウト
  resource :session, only: [ :new, :create, :destroy ]
  #
  resources :studios, only: [ :index ] do
    member do
      get "availability"
    end
    resources :reservations, only: [ :new, :destroy ] do
      collection do
        get :confirm
        post :finalize
      end
      member do
        get :complete
      end
    end
  end

  # ログイン・ログアウトのカスタムルート
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :admin do
    resources :studios, only: [] do
      resources :dashboard, only: [ :index ]
      resources :schedules, only: [] do
        member do
          patch :toggle
          patch "approve_reservation"
          patch "cancel_reservation"
        end
      end
    end
  end
end
