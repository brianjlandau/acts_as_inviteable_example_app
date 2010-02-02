ENV["RAILS_ENV"] = "test"
require 'rubygems'
gem 'sqlite3-ruby'
require 'active_support'
require 'active_support/test_case'
require 'action_mailer'
require 'active_record'
require 'shoulda/rails'
require File.expand_path( File.join(File.dirname(__FILE__), %w[.. init]) )


ActionMailer::Base.template_root = File.expand_path( File.join(File.dirname(__FILE__), %w[fixtures mailer_templates]) )
ActionMailer::Base.delivery_method = :test
ActiveRecord::Schema.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :users do |t|
      t.string :username, :null => false
      t.string :email
      t.integer :invitation_limit, :default => 5
      t.timestamps
    end
    
    create_table :invitations do |t|
      t.integer :sender_id
      t.string :token, :null => false
      t.string :recipient_email, :null => false
      t.timestamps
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class UserInvitationMailer < ActionMailer::Base  
  def invitation(invite)
    subject    "You've been sent an invitation to try out [SITE NAME]"
    recipients invite.recipient_email
    from       invite.sender.email
    sent_on    Time.current
    body       :invite => invite
  end
end


class ActsAsInvitationsTestCase < ActiveSupport::TestCase
  def setup
    setup_db
  end
  
  def teardown
    teardown_db
  end
end
