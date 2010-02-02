require 'acts_as_test_helper'

class ActsAsInvitationTest < ActsAsInvitationsTestCase
  context 'acts_as_invitation' do
    setup do
      class ::User < ::ActiveRecord::Base
        validates_presence_of :username
        acts_as_inviteable
      end

      class ::Invitation < ::ActiveRecord::Base
        acts_as_invitation
      end
      
      @user = ::User.new(:username => 'testuser', :email => 'user@example.com')
      @user.invite_not_needed = true
      @user.save!
      @user2 = ::User.new(:username => 'testuser2', :email => 'user2@example.com')
      @user2.invite_not_needed = true
      @user2.save!
    end
    
    context 'for Invitation model' do
      should 'belong to a sender user' do
        reflection = Invitation.reflect_on_association(:sender)
        assert !reflection.blank?
        assert_equal reflection.macro, :belongs_to
        assert Invitation.column_names.include?('sender_id')
      end
      
      should 'belong to a recipient' do
        reflection = Invitation.reflect_on_association(:recipient)
        assert !reflection.blank?
        assert_equal reflection.macro, :belongs_to
        assert Invitation.column_names.include?('recipient_email')
        assert User.column_names.include?('email')
      end
      
      should 'require "recipient_email"' do
        invite = Invitation.new
        assert invite.invalid?
        assert invite.errors.invalid?(:recipient_email)
        
        assert invite.recipient_email = "sombody@example.com"
        invite.valid?
        assert !invite.errors.invalid?(:recipient_email)
      end
      
      should 'require "sender_id"' do
        invite = Invitation.new
        assert invite.invalid?
        assert invite.errors.invalid?(:sender_id)
        
        assert invite.sender_id = 1
        invite.valid?
        assert !invite.errors.invalid?(:sender_id)
      end
      
      should 'require valid email addresses' do
        invite = Invitation.new(:recipient_email => 'blah')
        assert invite.invalid?
        assert invite.errors.invalid?(:recipient_email)
        
        assert invite.recipient_email = "sombody@example.com"
        invite.valid?
        assert !invite.errors.invalid?(:recipient_email)
      end
      
      should 'require a unique "recipient_email"' do
        invite = Invitation.new(:recipient_email => 'somebody1@example.com', :sender => @user)
        invite.save!
        
        invite2 = Invitation.new(:recipient_email => 'somebody1@example.com', :sender => @user)
        
        assert invite2.invalid?
        assert invite2.errors.invalid?(:recipient_email)
        
        invite2.recipient_email = "sombody#{rand(100)}@example.com"
        assert invite2.valid?
        assert !invite2.errors.invalid?(:recipient_email)
      end
      
      should 'require recipient to not be registered' do
        invite = Invitation.new(:recipient_email => @user2.email, :sender => @user)
        
        assert invite.invalid?
        assert invite.errors.invalid?(:recipient_email)
      end
      
      should 'require sender still has invitations to send' do
        @user2.invitation_limit = 0
        @user2.save!
        
        invite = Invitation.new(:recipient_email => 'somebody3@example.com', :sender => @user2)
        assert invite.invalid?
      end
      
      should 'generate a token when created' do
        invite = Invitation.new(:recipient_email => 'somebody4@example.com', :sender => @user)
        invite.save!
        
        assert !invite.token.blank?
      end
      
      should 'lower users invitation limit when created' do
        assert_difference '@user2.invitation_limit', -1 do
          invite = Invitation.new(:recipient_email => 'somebody5@example.com', :sender => @user2)
          invite.save!
        end
      end
      
      should 'send an email to the recipient' do
        assert_difference 'UserInvitationMailer.deliveries.count' do
          invite = Invitation.new(:recipient_email => 'somebody6@example.com', :sender => @user2)
          invite.save!
        end
        assert_sent_email do |email|
          email.from.include?(@user2.email) && email.to.include?('somebody6@example.com')
        end
      end
      
      should 'have by_created_at named scope' do
        assert ::ActiveRecord::NamedScope::Scope === Invitation.by_created_at
        assert_equal Invitation.by_created_at.proxy_options, {:order => 'created_at DESC'}
      end
      
      should 'have unaccepted named scope' do
        assert ::ActiveRecord::NamedScope::Scope === Invitation.unaccepted
        assert_equal Invitation.unaccepted.proxy_options, {
          :joins => "LEFT OUTER JOIN users on users.email = invitations.recipient_email",
          :conditions => ["users.id IS NULL"]
        }
      end
      
      should 'return true for "accepted?" if the invite has been accepted' do
        invite = Invitation.new(:recipient_email => 'somebody7@example.com', :sender => @user)
        invite.save!
        user = User.new(:username => 'user21', :invitation_code => invite.token)
        user.save!
        
        assert invite.accepted?
      end
      
      should 'return false for "accepted?" if the invite has not been accepted' do
        invite = Invitation.new(:recipient_email => 'somebody8@example.com', :sender => @user)
        invite.save!
        
        assert !invite.accepted?
      end
    end
    
    teardown do
      @user.destroy
      @user = nil
      @user2.destroy
      @user2 = nil
    end
  end
end
