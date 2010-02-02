require 'generator_test_init'

class InvitationsForGeneratorTest < GeneratorTestCase
  def setup
    super
    cp File.join(File.dirname(__FILE__), 'fixtures/user.rb'),  File.join(RAILS_ROOT, 'app/models/user.rb')
    # this is so the generator gets found
    cp_r File.join(PLUGIN_ROOT, 'generators/invitations_for'),  File.join(RAILS_ROOT, 'vendor/generators')
    Rails::Generator::Base.use_component_sources!
  end
  
  context 'invitations_for generator' do
    context 'without any options' do
      setup do
        run_generator('invitations_for', %w(User))
      end
      
      should 'generate invitation model' do
        assert_generated_model_for 'Invitation' do |body|
          assert_match(/acts_as_invitation \:user_class_name \=\> 'User'/, body)
        end
      end
      
      should 'generate invitation mailer' do
        assert_generated_model_for 'UserInvitationMailer', 'ActionMailer::Base' do |body|
          assert_has_method body, 'invitation'
        end
      end
      
      should 'generate invitation mailer view' do
        assert_generated_views_for 'UserInvitationMailer', 'invitation.erb'
      end
      
      should 'generate test for mailer' do
        assert_generated_unit_test_for 'UserInvitationMailer', 'ActionMailer::TestCase'
      end
      
      should 'generate test for model' do
        assert_generated_unit_test_for 'Invitation'
      end
      
      should 'generate migration for invitations' do
        assert_generated_migration 'CreateInvitations' do |body|
          assert_generated_table body, 'invitations'
          assert_generated_column body, 'sender_id', 'integer'
          assert_generated_column body, 'token', 'string'
          assert_generated_column body, 'recipient_email', 'string'
          assert_match(/add_column :users, :invitation_limit, :integer, :default => 5/, body)
          assert_match(/add_index :invitations, :sender_id/, body)
          assert_match(/add_index :invitations, :recipient_email, :unique => true/, body)
          assert_match(/add_index :invitations, :token, :unique => true/, body)
        end
      end
      
      should 'generate controller for invitations' do
        assert_generated_controller_for 'Invitations' do |body|
          assert_has_method body, 'new', 'create'
        end
      end
      
      should 'generate functional test for invitations controller' do
        assert_generated_functional_test_for 'Invitations'
      end
      
      should 'generate helper for invitations controller' do
        assert_generated_helper_for 'Invitations'
      end
      
      should 'generate helper test for invitations' do
        assert_generated_helper_test_for 'Invitations'
      end
      
      should 'generate views for invitations controller' do
        assert_generated_views_for 'Invitations', 'new.html.erb', 'create.html.erb'
      end
      
      should 'generate route for invitations' do
        assert_generated_file("config/routes.rb") do |body|
          assert_match(/map\.resource :invitation, :only => \[:new, :create\]/, body,
            "should add route for :invitations")
        end
      end
      
      should 'generate route for signup' do
        assert_generated_file("config/routes.rb") do |body|
          assert_match(/map\.signup '\/signup\/:invite_code', :controller => 'users', :action => 'new'/, body,
            "should add route for signup with invitations")
        end
      end
      
      should 'add acts_as_inviteable to user model' do
        assert_generated_model_for "User" do |body|
          assert_match(/acts_as_inviteable/, body)
        end
      end
    end
    
    context 'with "skip_controller" option' do
      setup do
        run_generator('invitations_for', %w(--skip-controller User))
      end
      
      should 'generate invitation model' do
        assert_generated_model_for 'Invitation' do |body|
          assert_match(/acts_as_invitation \:user_class_name \=\> 'User'/, body)
        end
      end
      
      should 'generate invitation mailer' do
        assert_generated_model_for 'UserInvitationMailer', 'ActionMailer::Base' do |body|
          assert_has_method body, 'invitation'
        end
      end
      
      should 'generate invitation mailer view' do
        assert_generated_views_for 'UserInvitationMailer', 'invitation.erb'
      end
      
      should 'generate test for mailer' do
        assert_generated_unit_test_for 'UserInvitationMailer', 'ActionMailer::TestCase'
      end
      
      should 'generate test for model' do
        assert_generated_unit_test_for 'Invitation'
      end
      
      should 'generate migration for invitations' do
        assert_generated_migration 'CreateInvitations' do |body|
          assert_generated_table body, 'invitations'
          assert_generated_column body, 'sender_id', 'integer'
          assert_generated_column body, 'token', 'string'
          assert_generated_column body, 'recipient_email', 'string'
          assert_match(/add_column :users, :invitation_limit, :integer, :default => 5/, body)
          assert_match(/add_index :invitations, :sender_id/, body)
          assert_match(/add_index :invitations, :recipient_email, :unique => true/, body)
          assert_match(/add_index :invitations, :token, :unique => true/, body)
        end
      end
      
      should 'not generate controller for invitations' do
        assert_no_file_exists 'app/controllers/invitations_controller.rb'
      end
      
      should 'not generate functional test for invitations controller' do
        assert_no_file_exists 'test/functional/invitations_controller_test.rb'
      end
      
      should 'not generate helper for invitations controller' do
        assert_no_file_exists 'app/helpers/invitations_helper.rb'
      end
      
      should 'not generate helper test for invitations' do
        assert_no_file_exists 'test/unit/helpers/invitations_helper_test.rb'
      end
      
      should 'not generate views for invitations controller' do
        assert_no_file_exists 'app/views/invitations/new.html.erb'
        assert_no_file_exists 'app/views/invitations/create.html.erb'
      end
      
      should 'not generate route for invitations' do
        assert_generated_file("config/routes.rb") do |body|
          assert_no_match(/map\.resource :invitation, :only => \[:new, :create\]/, body,
            "should add route for :invitations")
        end
      end
      
      should 'generate route for signup' do
        assert_generated_file("config/routes.rb") do |body|
          assert_match(/map\.signup '\/signup\/:invite_code', :controller => 'users', :action => 'new'/, body,
            "should add route for signup with invitations")
        end
      end
      
      should 'add acts_as_inviteable to user model' do
        assert_generated_model_for "User" do |body|
          assert_match(/acts_as_inviteable/, body)
        end
      end
    end
  end
end
