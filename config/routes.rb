Rails.application.routes.draw do
  root 'static_pages#home'
  get '/signup',   to: 'users#new'
  get '/help',     to: 'static_pages#help'
  get '/about',    to: 'static_pages#about'
  get '/contact',  to: 'static_pages#contact'
  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',to: 'sessions#destroy'
  resources :users
  # добавление ресурса активации учетных записей
  resources :account_activations, only: [:edit]
  # p_430: добавление ресурса для сброса пароля
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
