Rails.application.routes.draw do
  devise_for :clients
  root "home#index"
end
