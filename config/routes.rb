Rails.application.routes.draw do
  devise_for :clients

  root to: 'home#index'
  resources :equipment, only: [:index, :new, :create, :show]
end
