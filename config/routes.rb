Rails.application.routes.draw do
  root 'doctors#index', as: 'doctors_index'
  resources :appointments
  resources :users
  resources :doctors
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
