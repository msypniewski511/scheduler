Rails.application.routes.draw do
  resources :events do
    get :join, to: 'events#join', as: 'join'
    get :accept_request, to: 'events#accept_request', as:  'accept_request'
    get :reject_request, to: 'events#reject_request', as:  'reject_request'
  end

  get :dates, to: 'events#dates'

  root 'main#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
