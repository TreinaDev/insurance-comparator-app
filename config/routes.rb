Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  
  devise_for :clients
  resources :clients, only: [:show]
  resources :insurances, only: [:show]
  resources :equipment, only: [:index, :new, :create, :show]
end
