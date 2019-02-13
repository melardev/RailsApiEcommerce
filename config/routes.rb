Rails.application.routes.draw do
  scope :api, defaults: {format: :json} do

    resources :users do
      post 'login' => 'auth#login', on: :collection
    end
    post '/register', to: 'users#create', as: :register_user
    post '/auth/login', to: 'auth#login'

    get '/addresses' => 'addresses#my_addresses'
    resources :products do
      get '/by_id/:id' => :show, on: :collection

      resources :comments
    end
    resources :categories
    resources :tags
    resources :roles

    resources :order_items
    resources :orders

    # devise_for :users
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end

end
