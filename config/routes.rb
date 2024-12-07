Rails.application.routes.draw do
  resources :categories
  devise_for :users
  resources :posts do
    resources :comments, controller: "comments", only: [ :create, :reply ] do
      member do
        post :reply
      end
    end
  end
  resources :post_likes, controller: "likes", only: [ :create, :destroy ] do
  end
  # get '/user' => "render#index", :as => :user_root
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root to: redirect("/user")

  namespace :user do
    root to: "render#index"
  end
end
