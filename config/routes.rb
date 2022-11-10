Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'insurances#search'

  resources :insurances, only: [:show]

  devise_for :clients
  resources :clients, only: [:show]  
  devise_scope :client do  
    get '/clients/sign_out' => 'devise/sessions#destroy'
  end
  
  resources :equipment, only: [:index, :new, :create, :show]
end
