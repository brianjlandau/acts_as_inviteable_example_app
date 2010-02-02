require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context 'User' do
    setup do
      @user = Factory(:user)
    end
    subject { @user }
    
    should_be_authentic
    
    teardown do
      destroy_and_nil('user')
    end
  end
end
