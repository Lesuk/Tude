Rails.application.routes.draw do

  mount Soulmate::Server, :at => "/autocomplete"

  devise_for :users,  controllers: {registrations: "registrations"},
                      path: '', path_names: {sign_up: "register", sign_in: "login", sign_out: "logout", password: "secret", confirmation: "verification"}
  #, :path_prefix => "d"
  as :user do
    get 'users/:id/edit', to: 'registrations#edit', as: :user_edit
  end

  # DON'T USE Articles#index or Courses#index as ROOT PAGE!
  authenticated do
    root to: 'pages#dashboard', as: :authenticated_root
  end

  root to: 'pages#landing'

  # For pagination links, like: /page/2
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  resources :users, only: [:show] do
    member do
      get :courses
      get :reviews
      get :articles
      get :comments
      get :questions
      get :answers
    end
  end

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
      put :sort
      get :update_sections
    end
  end

  resources :courses do
    concerns :paginatable
    resources :reviews, only: [:new, :create, :update, :destroy]
    member do
      get :curriculum
      get :continue_course, path: 'continue', as: :continue
      post :favorite
    end
    collection do
      get :popular
      get :recommended
      get :favorites
      get :mine
      get :active
      get :completed
    end
  end

  resources :categories do
    member do
      get :articles
      get :questions
      get :quizzes
    end
  end

  resources :subscriptions, only: [:index] do
    collection do
      post :toggle, as: 'toggle_subscription'
    end
  end

  resources :enrollments, only: [:create, :destroy]
  resources :article_progresses, only: [:create, :destroy]
  resources :quizzes, except: [:show], controller: 'surveys' do
    resources :attempts, only: [:new, :create, :show], path_names: { new: '' }
    collection do
      get :popular
      get :favorites
    end
    member do
      post :favorite
    end
  end

  delete 'attempts/:survey_id' => 'attempts#delete_user_attempts', as: :delete_user_attempts

  get '/search/:action', to: 'searches#:action', as: 'search'

  post 'comments/:id/upvote', to: 'comments#upvote', as: 'upvote_comment'
  post 'comments/:id/downvote', to: 'comments#downvote', as: 'downvote_comment'
  post 'reviews/:id/upvote', to: 'reviews#upvote', as: 'upvote_review'
  post 'reviews/:id/downvote', to: 'reviews#downvote', as: 'downvote_review'

  get '/feed', to: 'activities#feed', as: 'feed'
  get '/feed/courses', to: 'activities#courses', as: 'courses_feed'
  get '/feed/articles', to: 'activities#articles', as: 'articles_feed'
  get '/feed/comments', to: 'activities#comments', as: 'comments_feed'
  get '/feed/questions', to: 'activities#questions', as: 'questions_feed'
  get '/feed/answers', to: 'activities#answers', as: 'answers_feed'
  get '/feed/users', to: 'activities#users', as: 'users_feed'
  get '/feed/personal', to: 'activities#personal', as: 'personal_feed'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of single route with pages
  # get '/search/:action/(page/:page)', controller: 'searches', action: ':action', to: 'searches#:action', as: 'search'

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
