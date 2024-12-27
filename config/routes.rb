# frozen_string_literal: true

Rails.application.routes.draw do
  root 'render#index'

  resources :categories, only: %i[index show new create]
  devise_for :users
  resources :posts do
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create]
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
end
