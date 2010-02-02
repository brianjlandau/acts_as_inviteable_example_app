require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  context 'UsersSessionsController' do
    setup do
      @user = Factory(:user)
    end
    
    context 'not logged in' do
      setup do
        logout
      end
      
      context 'get #new' do
        setup do
          get :new
        end

        should_assign_to :user_session, :class => UserSession
        should_respond_with :success
        should_render_template :new
        should_not_set_the_flash
      end

      context 'post #create' do
        setup do
          post :create, :user_session => {:login => @user.login, :password => 'password', :remember_me => '1'}
        end

        should_assign_to :user_session, :class => UserSession
        should_respond_with :redirect
        should_set_the_flash_to 'Welcome Back!'
        should_redirect_to('Homepage'){ root_url }
      end

      context 'post #create with bad data' do
        setup do
          post :create, :user_session => {:login => 'bogus@example.com', :password => 'blah', :remember_me => '0'}
        end

        should_assign_to :user_session, :class => UserSession
        should_respond_with :success
        should_render_template :new
      end
    end
    
    context 'logged in' do
      setup do
        login_as(@user)
      end
      
      context 'delete #destroy' do
        setup do
          delete :destroy
        end

        should_respond_with :redirect
        should_redirect_to('Login Page'){ login_url }
      end
      
      teardown do
        logout
      end
    end
    
    teardown do
      destroy_and_nil('user')
    end
  end
end
