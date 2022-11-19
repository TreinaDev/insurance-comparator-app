Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  get 'profile', to: 'clients#profile'
  devise_for :clients
  resources :insurances, only: [:show, :new, :create] do 
    resources :orders, only: [:new, :create, :show]
  end  
  resources :equipment, only: [:index, :new, :create, :show, :edit, :update]
end
