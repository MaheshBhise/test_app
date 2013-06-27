MasteryNew::Application.routes.draw do

  authenticated :user do
    root :to => "courses#my_courses"
  end

  root :to => 'logins#index'
  
  match 'courses/:id/course_info' => 'courses#course_info'
  resources :questions
  resources :courses do
    collection do
      get "join_course"
      get "get_all_sections"
      get "take_diagnostic"
      get "next_ques"
      get "next_question"
      get "log_exam_session"
      get "exam_intro"
      get "show_section"
      get "my_courses"
      get "view_all"
      get "time_up"
      get "test_result"
      get "lessons"
      get "diagnostics"
      get "reassess"
      get "show_subtopic_details"
    end
  end
  match 'courses/start_exam/:id' => 'courses#start_exam'
  match 'courses/get_all_sections/:id' => 'courses#get_all_sections'
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users , :controllers => {:confirmations => "confirmations", 
                                       :omniauth_callbacks => "omniauth_callbacks" }

  devise_scope :user do match "/users/sign_out" => "devise/sessions#destroy" end 


  resources :logins



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
  #root :to => 'logins#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
