Rails.application.routes.draw do
  root "home#index"
  get 'profile', to: 'clients#profile'
  devise_for :clients
  get 'search', to: 'products#search'

  resources :products, only: [:show] do 
    resources :insurances, only: [:index,:show] do 
      resources :orders, only: [:new, :create]
    end 
  end

  # get 'insurances', on: :member
  
  resources :orders, only: [:show, :index]
  resources :equipment, only: [:index, :new, :create, :show, :edit, :update]

end
