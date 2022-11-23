Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  get 'profile', to: 'clients#profile'
  devise_for :clients
  resources :insurances, only: [:show] do 
    resources :orders, only: [:new, :create]
  end  
  resources :orders, only: [:show, :index]
  resources :equipment, only: [:index, :new, :create, :show, :edit, :update]

  namespace :api do 
    namespace :v1 do 
      resources :orders, only: [] do 
        post 'payment_approved', on: :member 
        post 'payment_refused', on: :member 
      end
    end
  end
end
