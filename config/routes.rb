Rails.application.routes.draw do
  devise_for :clients

  root to: 'home#index'
  resources :equipments, only: [:index, :new, :create]
end
