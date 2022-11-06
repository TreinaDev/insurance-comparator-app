Rails.application.routes.draw do
  devise_for :clients
  root "home#index"
  devise_scope :client do  
    get '/clients/sign_out' => 'devise/sessions#destroy'
  end 
end
