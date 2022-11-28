Rails.application.routes.draw do
  root "home#index"
  get 'profile', to: 'clients#profile'
  devise_for :clients
  get 'search', to: 'products#search'

  resources :products, only: [:show] do 
    resources :insurances, only: [:index, :show, :new, :create] do 
      resources :orders, only: [:new, :create]
    end 
  end

  resources :orders, only: [:show, :index] do
    resources :payments, only: [:new, :create]
    resources :policies, only: [:index, :cancel] do
      post 'cancel_policy', on: :member
    end
    post 'voucher', on: :member
  end

  resources :equipment, only: [:index, :new, :create, :show, :edit, :update]

  namespace :api do 
    namespace :v1 do 
      resources :orders, only: [:show] do 
        post 'payment_approved', on: :member 
        post 'payment_refused', on: :member 
      end
      resources :payments, only: [:show], param: :order_id
      resources :orders, only: [:show, :update] do
        post 'insurance_approved', on: :member
        post 'insurance_disapproved', on: :member
      end
    end
  end

end
