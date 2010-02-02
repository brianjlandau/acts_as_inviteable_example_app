class User < ActiveRecord::Base
  acts_as_inviteable
  acts_as_authentic
end