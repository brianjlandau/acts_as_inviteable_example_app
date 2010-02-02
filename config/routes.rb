ActionController::Routing::Routes.draw do |map|
  
  map.resources :users, :only => [:new, :create]
  map.resource :account, :controller => "users", :only => [:edit, :update]
  map.resource :user_session, :only => [:new, :create, :destroy]

  map.register '/register', :controller => 'user',          :action => 'new'
  map.logout   '/logout',   :controller => 'user_sessions', :action => 'destroy'
  map.login    '/login',    :controller => 'user_sessions', :action => 'new'
  
  map.root :controller => 'home_page', :action => 'show'
  
end
