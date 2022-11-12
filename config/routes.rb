Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  resources :insurances, only: [:show]
  
  devise_for :clients
  get 'profile', to: 'clients#profile'
  resources :equipment, only: [:index, :new, :create, :show]
  resources :orders, only: [:new, :create]
  resources :payment, only: [:new]
end
