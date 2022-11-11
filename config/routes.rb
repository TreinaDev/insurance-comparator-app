Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  resources :insurances, only: [:show]
  
  devise_for :clients
  resources :clients, only: [:show]
  get 'profile', to: 'clients#profile'

  resources :equipment, only: [:index, :new, :create, :show]
end
