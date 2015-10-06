Rails.application.routes.draw do

  get 'profile/report'
  get 'profile/message'
  get 'profile/subscribe'

  get 'post/new'
  post 'post/new'
  get 'post/show'

  get 'post/create'
  post 'post/create'

  get 'post/comment'
  get 'post/upvote'
  get 'post/view'

  get 'search/searchByTag'
  get 'search/searchByText'
  get 'search/searchByUser'

  get 'event/new'
  post 'event/create'
  get 'event/show'

  get 'access/login'
  get 'access/logout'
  get 'access/finishLinkedInAuth'

  get 'home_feed/index'
  get 'home_feed/subscribe'

  #helper methods, to remove from this list after development
  get 'access/startLinkedInAuth'
  get 'event/createGoogleDoc'
  get 'event/createGoogleHangoutOnAir'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
