Rails.application.routes.draw do
  get 'admin_task/home'
  resources :products
  resources :stores
  resources :venders
  devise_for :users
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
