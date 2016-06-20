Rails.application.routes.draw do
  root to: 'baskets#index'

  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy', as: :logout

  resources :baskets, only: [:index, :show, :create, :update, :destroy]
end
