ENV["RAILS_ENV"] = "test"
$:.push(File.dirname(__FILE__))
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require "authlogic/test_case"

class ActiveSupport::TestCase

  protected
  
  def destroy_and_nil(*args)
    args.each do |ivar|
      unless instance_eval("@#{ivar}.nil?")
        instance_eval("@#{ivar}.destroy")
        instance_eval("@#{ivar} = nil")
      end
    end
  end
end

class ActionController::TestCase
  setup :activate_authlogic
  
  protected
  
  def login_as(user)
    unless user.is_a? User
      user = User.find_by_email(user)
    end
    UserSession.create(user)
  end
  
  def logout
    if controller.send(:current_user_session)
      controller.send(:current_user_session).destroy
      controller.instance_eval('@current_user_session = nil')
    end
  end
end  
