Rails.application.routes.draw do
  devise_for :clients
  root to: 'home#index'
  get 'search', to: 'home#search'
  
end
