Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "books#index"

  resources :books do
    resources :borrowings, only: [ :create ], controller: "borrowings" do
      member do
        patch :return_book
      end
    end
  end
  get :book_management, to: "books#book_management", as: :book_management
  devise_for :users

  # API endpoints
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "login", to: "authentication#login"
      post "signup", to: "authentication#signup"
      resources :books, only: [ :index, :create, :update, :destroy ]
      post "books/:book_id/borrowings", to: "borrowings#create"
      get "borrowings", to: "borrowings#index"
      # get "borrowings/:id", to: "borrowings#show"
      post "borrowings/:id/return", to: "borrowings#return_book"

      # Book Data
      get "data/genres", to: "data#genres"
      get "data/authors", to: "data#authors"
    end
  end
end
