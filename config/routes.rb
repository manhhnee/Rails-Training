# frozen_string_literal: true

Rails.application.routes.draw do
  # sessions
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  # static pages
  root "static_pages#home"
  get "static_pages/home"
  get "static_pages/help"
  # sign up
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :password_resets, only: %i(new create edit update)
  resources :account_activations, only: :edit
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: %i(create destroy)
end
