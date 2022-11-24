Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  get 'profile', to: 'clients#profile'
  devise_for :clients
  resources :insurances, only: [:show, :new, :create] do 
    resources :orders, only: [:new, :create]
  end  
  resources :orders, only: [:show, :index]
  resources :equipment, only: [:index, :new, :create, :show, :edit, :update]

  namespace :api do
    namespace :v1 do
      resources :orders, only: [:insurance_approved, :insurance_disapproved]
    end
  end
  
end
