# frozen_string_literal: true

Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'password_resets/create'
  get 'password_resets/update'
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
  resources :users
  resources :password_resets, only: %i(new edit create update)
  resources :account_activations, only: %i(new edit create update)
end
