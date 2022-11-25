Rails.application.routes.draw do
  root "home#index"
  get 'profile', to: 'clients#profile'
  devise_for :clients
  get 'search', to: 'products#search'

  resources :products, only: [:show] do 
    resources :insurances, only: [:index, :show, :new, :create] do 
      resources :orders, only: [:new, :create, :update]
    end 
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
      resources :orders, only: [:show, :update] do
        post 'insurance_approved', on: :member
        post 'insurance_disapproved', on: :member
      end
    end
  end

end
