require 'active_record'
require 'acts_as_inviteable/regex'
require 'digest/sha1'

module ActiveRecord # :nodoc:
  module ActsAs # :nodoc:
    module Invitation
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_invitation(options = {})
          options.reverse_merge!(:user_class_name => 'User')
          unless (self.respond_to?(:acts_as_invitation_config) && self.acts_as_invitation_config.present? && self.method_defined?(:accepted?))
            cattr_accessor :acts_as_invitation_config
            self.acts_as_invitation_config = options
            include InstanceMethods
          
            belongs_to :sender, :class_name => options[:user_class_name]
            belongs_to :recipient, :class_name => options[:user_class_name], :foreign_key => 'recipient_email', :primary_key => 'email'

            validates_presence_of :recipient_email
            validates_presence_of :sender_id, :on => :create
            validates_format_of :recipient_email, :with => ::ActsAsInviteable::Regex.email, :allow_blank => true
            validates_uniqueness_of :recipient_email, :token, :case_sensitive => false, :allow_blank => true
            validate :recipient_is_not_registered
            validate :sender_has_invitations

            before_create :generate_token
            after_create  :decrement_sender_count
            after_create  :send_invite_email

            named_scope :by_created_at, :order => 'created_at DESC'

            named_scope :unaccepted, :joins => "LEFT OUTER JOIN #{options[:user_class_name].tableize} on #{options[:user_class_name].tableize}.email = invitations.recipient_email",
                                     :conditions => ["#{options[:user_class_name].tableize}.id IS NULL"]
          end
        end
      end
      
      module InstanceMethods
        def accepted?
          recipient.present?
        end

        private
          def recipient_is_not_registered
            if self.class.acts_as_invitation_config[:user_class_name].constantize.find_by_email(recipient_email)
              errors.add :recipient_email, 'is already registered'
            end
          end

          def sender_has_invitations
            unless sender.try(:invitation_limit).to_i > 0
              errors.add_to_base 'You have reached your limit of invitations to send.'
            end
          end

          def generate_token
            self.token = ::Digest::SHA1.hexdigest([Time.now, recipient_email, rand].join)
          end

          def decrement_sender_count
            sender.decrement! :invitation_limit
          end

          def send_invite_email
            mailer_name = "#{self.class.acts_as_invitation_config[:user_class_name]}InvitationMailer"
            mailer_name.constantize.deliver_invitation(self)
          end
      end
    end
  end
end
