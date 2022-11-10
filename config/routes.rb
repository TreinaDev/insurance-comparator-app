Rails.application.routes.draw do
  devise_for :clients
  resources :clients, only: [:show]
  root "home#index"
  get 'search', to: 'home#search'
  resources :equipment, only: [:index, :new, :create, :show]
end
