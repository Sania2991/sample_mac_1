Rails.application.routes.draw do
  root 'static_pages#home'
    # 195
  get '/signup',   to: 'users#new'
    # 189...
  get '/help',     to: 'static_pages#help'
  get '/about',    to: 'static_pages#about'
  get '/contact',  to: 'static_pages#contact'
    # 290
  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',to: 'sessions#destroy'

    # ...189
    # 246: обеспечивает автоматич. вызов всех методов действий
      # для RESTful-ресурса Users
  resources :users
end
