require 'active_support'
require 'acts_as/invitation'
require 'acts_as/inviteable'

ActiveRecord::Base.send :include, ActiveRecord::ActsAs::Inviteable
ActiveRecord::Base.send :include, ActiveRecord::ActsAs::Invitation
