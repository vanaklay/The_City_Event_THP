Rails.application.routes.draw do
  get 'pictures/create'
  root 'events#index'
  devise_for :users
  resources :events do 
    resources :attendances
    resources :pictures, only: [:create]
  end
  resources :users, only: [:show, :edit, :update]
  
end
