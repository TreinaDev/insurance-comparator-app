Rails.application.routes.draw do
  devise_for :clients

  root "home#index"
  get 'search', to: 'home#search'

  authenticate :client do
    resources :clients, only: [:show]  
    devise_scope :client do  
      get '/clients/sign_out' => 'devise/sessions#destroy'
    end

    resources :equipment, only: [:index, :new, :create, :show]
  end

  resources :equipment, only: [:index, :new, :create, :show]
end
