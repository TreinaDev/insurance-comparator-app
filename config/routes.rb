Rails.application.routes.draw do
  devise_for :clients
  get 'profile', to: 'clients#profile'
  root "home#index"
  get 'search', to: 'home#search'
  resources :equipment, only: [:index, :new, :create, :show] do
    resources :policy, only: [:new, :create, :show]    
  end
end
