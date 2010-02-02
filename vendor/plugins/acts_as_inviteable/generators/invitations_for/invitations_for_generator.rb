class InvitationsForGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.class_collisions "Invitation", "#{class_name}InvitationMailer", "CreateInvitations", 
                         'InvitationTest', "#{class_name}InvitationMailerTest"
      unless options[:skip_controller]
        m.class_collisions "InvitationsController", 'InvitationsHelper', 'InvitationsHelperTest',
                           'InvitationsControllerTest'
      end
      if options[:create_user_model]
        m.class_collisions class_name
      end
      
      m.directory 'test/functional'
      m.directory 'test/unit'
      m.directory 'app/models'
      m.directory "app/views/#{file_name}_invitation_mailer"
      
      if options[:create_user_model]
        m.dependency 'model', [class_name]
      end
      
      m.template 'invitation.rb', 'app/models/invitation.rb'
      m.template 'user_invitation_mailer.rb', "app/models/#{file_name}_invitation_mailer.rb"
      m.template 'invitation.erb', "app/views/#{file_name}_invitation_mailer/invitation.erb"
      
      m.template "mailer_test.rb", File.join('test/unit', "#{file_name}_invitation_mailer_test.rb")
      m.template 'invitation_test.rb',  File.join('test/unit', "invitation_test.rb")
      
      m.migration_template 'invitation_migration.rb', 'db/migrate', :migration_file_name => "create_invitations"
      
      unless options[:skip_controller]
        m.dependency 'controller', ['Invitations', 'new', 'create']
      end
      
      unless options[:skip_controller]
        logger.route "map.resource :invitation, :only => [:new, :create]"
      end
      logger.route "map.signup   '/signup/:invite_code', :controller => '#{plural_name}', :action => 'new'"
      logger.edit  "#{class_name} Model: added `acts_as_inviteable`"
      unless options[:pretend]
        routing_sentinel = 'ActionController::Routing::Routes.draw do |map|'
        
        unless options[:skip_controller]
          gsub_file 'config/routes.rb', /(#{Regexp.escape(routing_sentinel)})/mi do |match|
            "#{match}\n  map.resource :invitation, :only => [:new, :create]\n"
          end
        end
        
        gsub_file 'config/routes.rb', /(#{Regexp.escape(routing_sentinel)})/mi do |match|
          "#{match}\n  map.signup '/signup/:invite_code', :controller => '#{plural_name}', :action => 'new'\n"
        end
        
        model_sentinel = "class #{class_name} < ActiveRecord::Base"
        gsub_file "app/models/#{file_name}.rb", /(#{Regexp.escape(model_sentinel)})/mi do |match|
          "#{match}\n  acts_as_inviteable\n"
        end
      end
      
      m.readme "README"
    end
  end
  
  protected
    def banner
      "Usage: #{$0} #{spec.name} UserModelName"
    end
    
    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-controller",
             "Don't create a controller for creating/sending invitations") { |v| options[:skip_controller] = v }
      opt.on("--create-user-model",
             "Create the User model too (usefull if you haven't already done this)") { |v|
               options[:create_user_model] = v
             }
    end
    
  private
    # pulled from rails: lib/rails_generator/commands.rb
    def gsub_file(relative_destination, regexp, *args, &block)
      path = destination_path(relative_destination)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
    end
  
end
