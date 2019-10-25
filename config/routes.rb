Rails.application.routes.draw do
  resources :about
  resources :product_category
  resources :what_new
  resources :cities
  resources :advertisements
  resources :jobs
  resources :comments
  resources :ratings
  resources :profiles
  resources :contact_us
  resources :products do
    collection do
      post :popular_list
      get :popular_list
    end
  end
  resources :stores
  resources :venders
  resources :vendors do
    collection do
      post :popular_list
      get :popular_list
      post :popular_architect
      get :popular_architect
      post :popular_interior_designer
      get :popular_interior_designer
    end
  end
  resources :projects
  resources :blogs do
    collection do
      post :search
      get :search
    end
  end
  resources :home do
    collection do
      post :search
      get :search
    end
  end


  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  root 'home#index'
  devise_scope :user do
    get "admin" => "users/sessions#new"
  end
  namespace :admin do
    get 'admin_task/home'
    resources :users
    resources :categories
    resources :companies
    resources :colors
    resources :comments
    resources :product_types
    resources :product_categories
    resources :profiles
    resources :cities
    resources :blogs
    resources :jobs
    resources :advertisements
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
