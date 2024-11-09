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
end
