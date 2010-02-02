class Invitation < ActiveRecord::Base
  acts_as_invitation :user_class_name => 'User'
end
