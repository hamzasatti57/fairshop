Rails.application.routes.draw do
  
  resources :confirmation
  resources :cart
  resources :checkout
  resources :tracking
  resources :brands
  resources :about
  resources :product_category
  resources :what_new
  resources :cities
  resources :advertisements
  resources :jobs
  resources :comments
  resources :ratings
  resources :likes
  resources :billing_addresses
  resources :profiles do
    collection do
      post :update_download_catalog_count
      get :update_download_catalog_count
    end
  end
  resources :job_mails do
    collection do
      post :job_email_send
      get :job_email_send
    end
  end
  resources :contact_us
  resources :products do
    collection do
      post :popular_list
      get :discounted_items
      get :favourites
      post :save_cart
    end
    member do
      post :add_to_cart
      get :get_comments
    end
  end
  resources :venders
  resources :vendors do
    collection do
      post :popular_list
      get :popular_list
      post :popular_architect
      get :popular_architect
      post :popular_interior_designer
      get :popular_interior_designer
      post :aaa_caetgory
      get :aaa_caetgory
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
      registrations: 'users/registrations',
      passwords: 'users/passwords'
  }

  root 'home#index'
  get '/brand_products' => 'product_category#brand_products'
  get '/store_locator' => 'contact_us#store_locator'
  get '/privacy_policy' => 'about#privacy_policy'
  get '/disclaimer' => 'about#disclaimer'
  get '/employee_bursaries' => 'about#employee_bursaries'
  get '/terms_and_conditions' => 'about#terms_and_conditions'
  get '/domicile_and_regulation' => 'about#domicile_and_regulation'
  post '/notify' => 'checkout#notify'
  get '/cancel' => 'checkout#cancel_payment'
  get '/peach_payment' => 'checkout#peach_payment'
  post '/peach_payment' => 'checkout#peach_payment_request'
  get '/product_detail' => 'products#product_detail'
  delete '/delete_cart_product/:id' => 'cart#delete_cart_product', :as => 'delete_cart_product'
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
    resources :countries do
      collection do
        get :get_cities
      end
    end
    resources :product_types
    resources :product_categories
    resources :profiles
    resources :cities
    resources :blogs
    resources :jobs
    resources :dashboards
    resources :reports do
      collection do

        post :category_reporting
        get :category_reporting
        post :user_reporting
        get :user_reporting
        post :detail_product_project_hits
        get :detail_product_project_hits
        post :detail_product_project_likes
        get :detail_product_project_likes
        post :detail_product_project_comments
        get :detail_product_project_comments

      end
    end
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
      collection do
        get :bulk_upload
        post :bulk_upload_products
      end
    end
    resources :stores do
      collection do
        get :bulk_upload
        post :bulk_upload_stores
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
