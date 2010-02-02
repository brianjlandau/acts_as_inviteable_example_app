require 'acts_as_test_helper'

class ActsAsInviteableTest < ActsAsInvitationsTestCase
  context 'acts_as_inviteable' do
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
    end
    
    context 'for a User model' do
      should 'have many sent invitations' do
        reflection = User.reflect_on_association(:sent_invitations)
        assert !reflection.blank?
        assert_equal reflection.macro, :has_many
        assert Invitation.column_names.include?('sender_id')
        assert_equal reflection.options[:dependent].to_sym, :nullify
      end

      should "have a default of 5 for the invite limit" do
        assert_equal User.default_invitation_limit, 5
      end

      should "have an initial value for invitation_limit" do
        assert_equal @user.invitation_limit, 5
      end
      
      should 'use the email from the invite' do
        invite = Invitation.new(:sender => @user, :recipient_email => 'jay-z@nyc.com')
        invite.save!
        
        user = User.new(:username => 'jayz', :invitation_code => invite.token)
        user.save!
        
        assert_equal user.email, invite.recipient_email
      end
      
      should 'require a valid invite code' do
        user = User.new(:username => 'biz')
        assert user.invalid?
        assert user.errors.invalid?(:invitation_code)
        
        invite = Invitation.new(:sender => @user, :recipient_email => 'thebiz@example.com')
        invite.save!
        
        user.invitation_code = invite.token
        
        assert user.valid?
      end
      
      should 'protect "invite_not_needed" attribute' do
        assert User.protected_attributes.include?('invite_not_needed')
      end
      
      should 'protect "invitation_limit" attribute' do
        assert User.protected_attributes.include?('invitation_limit')
      end
    end
    
    teardown do
      @user.destroy
      @user = nil
    end
  end
end
