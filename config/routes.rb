Rails.application.routes.draw do
  devise_for :clients
  resources :clients, only: [:show]
  root "home#index"
  get 'search', to: 'home#search'
  
  devise_scope :client do  
    get '/clients/sign_out' => 'devise/sessions#destroy'
  end

  resources :equipment, only: [:index, :new, :create, :show]
end
