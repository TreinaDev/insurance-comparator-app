Rails.application.routes.draw do
  root "home#index"
  get 'search', to: 'home#search'
  get 'show/:id', to: 'home#show', as: 'show'

  devise_for :clients
  resources :clients, only: [:show]  
  devise_scope :client do  
    get '/clients/sign_out' => 'devise/sessions#destroy'
  end  
end
