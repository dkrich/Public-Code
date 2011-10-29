Topscores::Application.routes.draw do
  resources :cities

  resources :vendors
  resources :vendor_profiles

  match 'orders/express_confirmation/:id', :to => "orders#express_confirmation"
  match 'orders/express/:id', :to => "orders#express"
  match 'orders/new/:id', :to => "orders#new"
  resources :orders

  devise_for :users, :controllers => { :sessions => 'sessions', :registrations => 'registrations', :passwords => 'passwords' }

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  match 'account' => 'users#show'

  match 'users/user_admin', :to => "users#user_admin"
  match 'users/view_user_orders/:id', :to => "users#view_user_orders"
  match 'users/switch_to_standard', :to => "users#switch_to_standard"
  match 'users/switch_to_salad', :to => "users#switch_to_salad"
  match 'users/switch_to_different', :to => "users#switch_to_different"
  match 'users/request_location', :to => "users#request_location"
  match 'users/send_location_request', :to => "users#send_location_request"
  match 'users/start_order', :to => "users#start_order"

  match 'users/add_meal_to_order', :to => "users#add_meal_to_order"
  match 'users/remove_from_order', :to => "users#remove_from_order"
  match 'users/send_order', :to => "users#send_order"

  match 'menus/set_selections', :to => "menus#set_selections"
  match 'menus/update_selections', :to => "menus#update_selections"
  match 'menus/update_name', :to => "menus#update_name"
  match 'menus/add_item_to_menu', :to => "menus#add_item_to_menu"
  match 'menus/remove_item_from_menu', :to => "menus#remove_item_from_menu"
  match 'menus/set_location_selections', :to => "menus#set_location_selections"
  match 'menus/update_location_selections', :to => "menus#update_location_selections"

  match 'drop_off_locations/schedule', :to => "drop_off_locations#schedule"
  match 'drop_off_locations/edit_times', :to => "drop_off_locations#edit_times"
  match 'drop_off_locations/new/:drop_off_location_id', :to => "drop_off_locations#new"

  match 'users/change_meal_order_destination', :to => "users#change_meal_order_destination"
  match 'users/change_meal_order_location', :to => "users#change_meal_order_location"

  match 'users/edit_settings', :to => "users#edit_settings"
  match 'users/update_settings', :to => "users#update_settings"
  match 'users/finished_updating', :to => "users#finished_updating"
  match 'users/change_permanent_location', :to => "users#change_permanent_location"
  match 'users/update_location', :to => "users#update_location"

  match 'users/remove_flash', :to => "users#remove_flash"

  match 'users/create_user_location', :to => "users#create_user_location"
  #map.connect 'users/purchase_credits', :controller => "users", :action => "purchase_credits"
  match 'users/purchase_credits', :to => "users#purchase_credits"
  #map.connect 'users/default_schedule_explanation', :controller => "users", :action => "default_schedule_explanation"
  match 'users/default_schedule_explanation', :to => "users#default_schedule_explanation"
  #map.connect 'users/how', :controller => "users", :action => "how"
  match 'users/how', :to => "users#how"
  #map.connect 'users/explanations', :controller => "users", :action => "explanations"
  match 'users/explanations', :to => "users#explanations"
  #map.connect 'users/about_us', :controller => "users", :action => "about_us"
  match 'users/about_us', :to => "users#about_us"
  #map.connect 'users/update_delivery_statuses', :controller => "users", :action => "update_delivery_statuses"
  match 'users/update_delivery_statuses', :to => "users#update_delivery_statuses"
  #map.connect 'users/outstanding_orders', :controller => "users", :action => "outstanding_orders"
  match 'users/outstanding_orders', :to => "users#outstanding_orders"
  #map.connect 'users/delivery_schedule', :controller => "users", :action => "delivery_schedule"
  match 'users/delivery_schedule', :to => "users#delivery_schedule"
  #map.connect 'menus/schedule', :controller => "menus", :action => 'schedule'
  match 'menus/schedule', :to => "menus#schedule"
  #map.connect 'users/step_four', :controller => 'users', :action => 'step_four'
  match 'users/step_four', :to => "users#step_four"
  #map.connect 'users/create_location_recipient', :controller => 'users', :action => 'create_location_recipient'
  match 'users/create_location_recipient', :to => "users#create_location_recipient"
  #map.connect 'menus/admin_index', :controller => 'menus', :action => 'admin_index'
  match 'users/admin_index', :to => "users#admin_index"
  #map.connect 'users/show_all_locations', :controller => 'users', :action => 'show_all_locations'
  match 'users/show_all_locations', :to => "users#show_all_locations"

  match 'login' => "user_sessions#new", :as => "login"

  resources :administrators
  
  resources :meal_types

  resources :drop_off_location_times

  resources :drop_off_locations

  resources :items

  resources :password_resets

  resources :menu_items

  resources :menus

  resources :users

  resources :user_service_plans

  resources :user_sessions

  #resource :account, :controller => 'users'
  #resource :account, :controller => "users", :as => "users"
  #match "account" => "users", :as => :account  

  #map.login "login", :controller => "user_sessions", :action => "new"
  #map.logout "logout", :controller => "user_sessions", :action => "destroy"
  
  #match "login" => "user_sessions#new", :as => :login
  #match "logout" => "user_sessions#destroy", :as => :logout

  root :to => "users#show"
  match '*path', :to => "users#show"
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
  #map.connect '*path', :controller => 'users', :action => 'show'
end
