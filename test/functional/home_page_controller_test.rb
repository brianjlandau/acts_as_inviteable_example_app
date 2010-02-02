require 'test_helper'

class HomePageControllerTest < ActionController::TestCase
  context 'HomePageController' do
    context 'get #show' do
      setup do
        get :show
      end
      
      should_respond_with :success
      should_render_template :show
      should_not_set_the_flash
    end
  end
end
