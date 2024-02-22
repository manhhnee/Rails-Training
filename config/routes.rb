# frozen_string_literal: true

Rails.application.routes.draw do
  #sessions
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  #static pages
  root "static_pages#home"
  get "static_pages/home"
  get "static_pages/help"
  #sign up
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  resources :users, only: :show

end
