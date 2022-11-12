Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  
  devise_for :clients
  get 'profile', to: 'clients#profile'
  resources :insurances, only: [:show]
  resources :equipment, only: [:index, :new, :create, :show]
end
