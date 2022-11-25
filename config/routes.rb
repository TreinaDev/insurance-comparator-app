Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'
  get 'profile', to: 'clients#profile'
  devise_for :clients
  resources :insurances, only: [:show, :new, :create] do 
    resources :orders, only: [:new, :create]
  end  
  resources :orders, only: [:show, :index] do
    resources :payments, only: [:new, :create]
  end
  resources :equipment, only: [:index, :new, :create, :show, :edit, :update]

  namespace :api do
    namespace :v1 do
      resources :payments, only: [:show], param: :order_id do
        post 'approved', on: :member  
        post 'refused', on: :member      
      end
      resources :orders, only: [:show]
    end
  end
end
