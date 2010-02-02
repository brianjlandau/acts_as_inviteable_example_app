ActionController::Routing::Routes.draw do |map|
  
  map.signup '/signup/:invite_code', :controller => 'users', :action => 'new'
  map.resource :invitation, :only => [:new, :create]
  
  map.resources :users, :only => [:new, :create]
  map.resource :account, :controller => "users", :only => [:edit, :update]
  
  map.resource :user_session, :only => [:new, :create, :destroy]
  map.logout   '/logout',   :controller => 'user_sessions', :action => 'destroy'
  map.login    '/login',    :controller => 'user_sessions', :action => 'new'
  
  map.root :controller => 'home_page', :action => 'show'
  
end
