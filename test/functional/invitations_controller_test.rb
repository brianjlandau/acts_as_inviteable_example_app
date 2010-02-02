require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  context 'InvitationsController' do
    setup do
      @user = Factory(:user)
    end
    
    context 'logged in' do
      setup do
        login_as @user
      end
      
      context 'get #new' do
        setup do
          get :new
        end

        should_assign_to :invitation, :class => Invitation
        should_respond_with :success
        should_render_template :new
        should_not_set_the_flash
      end

      context 'post #create with bad data' do
        setup do
          post :create, :invitation => {:recipient_email => ''}
        end

        should_not_change('Number of invites') do
          Invitation.count
        end
        
        should_not_change 'Number of users invitation_limit' do
          @user.reload.invitation_limit
        end
        
        should_not_change 'Number of invite emails' do
          UserInvitationMailer.deliveries.count
        end

        should_assign_to :invitation, :class => Invitation
        should_respond_with :success
        should_render_template :new
        should_not_set_the_flash
      end

      context 'post #create with good data' do
        setup do
          @email = Factory.next(:email)
          post :create, :invitation => {:recipient_email => @email}
        end

        should_change 'Number of invites', :by => 1 do
          Invitation.count
        end
        
        should_change 'Number of invites for user', :by => 1 do
          @user.sent_invitations.count
        end
        
        should_change 'Number of users invitation_limit', :by => -1 do
          @user.reload.invitation_limit
        end
        
        should_change 'Number of invite emails', :by => 1 do
          UserInvitationMailer.deliveries.count
        end
        
        should 'send email' do
          assert_sent_email do |email|
            email.from.include?(@user.email) && email.to.include?(@email)
          end
        end

        should_assign_to :invitation, :class => Invitation
        should_respond_with :redirect
        should_redirect_to('Root page'){ root_url }
        should_set_the_flash_to 'Thank you, the invitation has been sent.'
      end
    end
    
    teardown do
      destroy_and_nil('user')
    end
  end
end
