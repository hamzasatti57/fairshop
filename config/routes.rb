Rails.application.routes.draw do
  resources :products
  resources :stores
  resources :venders

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  root 'home#index'
  namespace :admin do
    get 'admin_task/home'
    resources :users
    resources :categories
    resources :profiles
    resources :projects do
      member do
        delete :delete_image_attachment
      end
    end
    resources :products do
      member do
        delete :delete_image_attachment
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
