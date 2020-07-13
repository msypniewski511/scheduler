Rails.application.routes.draw do
  resources :events do
    get :join, to: 'events#join', as: 'join'
  end
  root 'main#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
