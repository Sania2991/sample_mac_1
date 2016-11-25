Rails.application.routes.draw do
  root 'static_pages#home'
  # p_195
  get '/signup',  to: 'users#new'
  # p_189 ...
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  # ... p_189
end
