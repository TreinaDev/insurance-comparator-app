Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  get 'profile', to: 'clients#profile'
  devise_for :clients
  resources :insurances, only: [:show] do 
    resources :orders, only: [:new, :create]
  end  
  resources :orders, only: [:show, :index] do
    resources :payments, only: [:new, :create]
  end
  resources :equipment, only: [:index, :new, :create, :show, :edit, :update]

  namespace :api do
    namespace :v1 do
      resources :payments, only: [:show, :update]
    end
  end
end
