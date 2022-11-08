Rails.application.routes.draw do
  devise_for :clients
  root to: 'home#index'
  get 'search', to: 'home#search'
  get 'show/:id', to: 'home#show', as: 'show'
  
  devise_scope :client do  
    get '/clients/sign_out' => 'devise/sessions#destroy'
  end 
end
