Rails.application.routes.draw do
  resources :items
  root to: 'baskets#index'

  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy', as: :logout

  resources :baskets, only: [:index, :show, :create, :update, :destroy] do
    resources :products, only: [:create, :update, :destroy], shallow: true
  end

  mount(ActionCable.server => "/cable") unless Nenv.cable_url?
end
