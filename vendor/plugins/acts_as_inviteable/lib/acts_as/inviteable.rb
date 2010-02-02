require 'active_record'

module ActiveRecord # :nodoc:
  module ActsAs # :nodoc:
    module Inviteable
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_inviteable(options = {})
          unless (self.method_defined?(:invitation) && self.method_defined?(:invitation_code) && self.respond_to?(:default_invitation_limit) && self.default_invitation_limit.present?)
            include InstanceMethods
          
            cattr_accessor :default_invitation_limit
            self.default_invitation_limit = options[:default_invitation_limit].blank? ? 
              self.columns_hash["invitation_limit"].default :
              options[:default_invitation_limit]
            attr_accessor :invitation_code, :invite_not_needed
            attr_protected :invite_not_needed, :invitation_limit
          
            has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id', :dependent => :nullify
            validate_on_create :invite_code_valid

            before_create :set_invitation_limit
            before_validation_on_create :set_email_from_invite
          end
        end
      end
      
      module InstanceMethods
        def invitation
          @invitation ||= ::Invitation.find_by_token(invitation_code)
        end

        private
          def invite_code_valid
            unless invitation || invite_not_needed
              errors.add(:invitation_code, "is not a valid invite code")
            end
          end

          def set_invitation_limit
            self.invitation_limit = self.class.default_invitation_limit
          end

          def set_email_from_invite
            self.email = invitation.recipient_email if invitation
          end
      end
    end
  end
end
