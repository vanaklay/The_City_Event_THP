Rails.application.routes.draw do
  root 'events#index'
  devise_for :users
  resources :events do 
    resources :attendances
    resources :pictures, only: [:create]
  end
  resources :users, only: [:show, :edit, :update] do
    resources :avatars, only: [:create]
  end
  
end
