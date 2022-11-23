Rails.application.routes.draw do
  root "home#index"
  get 'profile', to: 'clients#profile'
  devise_for :clients
  get 'search', to: 'products#search'
  resources :insurances, only: [:show, :index] do 
    resources :orders, only: [:new, :create]
  end  
  resources :orders, only: [:show, :index]
  resources :equipment, only: [:index, :new, :create, :show, :edit, :update]

  resources :product_model, only: [:index]
end
