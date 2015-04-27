Rails.application.routes.draw do

  devise_for :users,  controllers: {registrations: "registrations"},
                      path: '', path_names: {sign_up: "register", sign_in: "login", sign_out: "logout", password: "secret", confirmation: "verification"}
  #, :path_prefix => "d"

  # For pagination links, like: /page/2
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  root 'users#show'

  # resources :users, only: [:show]
  get 'users/:id', to: 'users#show', as: 'user'
  post 'comments/:id/upvote', to: 'comments#upvote', as: 'upvote_comment'
  post 'comments/:id/downvote', to: 'comments#downvote', as: 'downvote_comment'

  resources :articles do
    concerns :paginatable
    resources :comments, only: [:new, :create, :update, :destroy]
    member do
      post :favorite
      post :like
    end
    collection do
      get :popular
      get :favorites
      get :recommended
      get :mine
      get :top
      post :sort
    end
  end
  resources :categories
  resources :courses do
    member do
      get :curriculum
      get :next_article, path: 'next'
    end
  end
  resources :enrollments, only: [:create, :destroy]

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
