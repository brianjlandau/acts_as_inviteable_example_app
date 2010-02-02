class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :sender_id
      t.string :token, :null => false
      t.string :recipient_email, :null => false
      t.timestamps
    end
    add_column :<%= table_name %>, :invitation_limit, :integer, :default => 5
    add_index :invitations, :sender_id
    add_index :invitations, :recipient_email, :unique => true
    add_index :invitations, :token, :unique => true
  end

  def self.down
    remove_index :invitations, :column => :sender_id
    remove_index :invitations, :column => :recipient_email
    remove_index :invitations, :column => :token
    remove_column :<%= table_name %>, :invitation_sent_count
    drop_table :invitations
  end
end
