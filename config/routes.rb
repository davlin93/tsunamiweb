Tsunami::Application.routes.draw do
  root :to => 'splash#index'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  get 'auth/facebook', :as => 'login'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  get 'waves', to: 'waves#index'
  get 'api/dashboard', to: 'dashboard#index'
  post 'api/dashboard', to: 'dashboard#generate'
  delete 'api/dashboard', to: 'dashboard#undo'

  namespace :api do
    resources :users, only: [:index, :create, :update, :show]
    get 'users/:id/waves', to: 'users#waves'

    resources :splash
    resources :ripple, only: [:index, :create]
    post 'ocean/dismiss', to: 'ocean#dismiss'
    get 'ocean/local_waves', to: 'ocean#local_waves'
    get 'ocean/all_waves', to: 'ocean#all_waves'
    post 'ocean/splash', to: 'ocean#splash'

    resources :comments, only: [:create]
  end

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
