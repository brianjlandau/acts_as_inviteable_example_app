require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'UsersController' do
    
    context 'get #new' do
      setup do
        get :new
      end
      
      should_assign_to :user, :class => User
      should_respond_with :success
      should_render_template :new
      should_not_set_the_flash
    end
    
    context 'post #create with bad data' do
      setup do
        post :create, :user => {:login => '', :email => '', :password => '', :password_confirmation => ''}
      end
      
      should_not_change('Number of Users') do
        User.count
      end
      
      should_assign_to :user, :class => User
      should_respond_with :success
      should_render_template :new
      should_not_set_the_flash
    end
    
    context 'post #create with good data' do
      setup do
        post :create, :user => {
          :login => 'billfish', 
          :email => 'billfish@example.com', 
          :password => 'password', 
          :password_confirmation => 'password' }
      end
      
      should_change 'Number of users', :by => 1 do
        User.count
      end
      
      should_assign_to :user, :class => User
      should_respond_with :redirect
      should_redirect_to('Root page'){ root_url }
      should_set_the_flash_to 'You have successfully registered.'
    end
    
  end
end
