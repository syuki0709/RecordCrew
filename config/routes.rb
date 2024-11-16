Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "studios#index"
  # ユーザー登録
  resources :users, only: [:new, :create]
  # ログイン・ログアウト
  resource :session, only: [:new, :create, :destory]

  # ログイン・ログアウトのカスタムルート
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
