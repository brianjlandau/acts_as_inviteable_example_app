# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100202021613) do

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "token",           :null => false
    t.string   "recipient_email", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["recipient_email"], :name => "index_invitations_on_recipient_email", :unique => true
  add_index "invitations", ["sender_id"], :name => "index_invitations_on_sender_id"
  add_index "invitations", ["token"], :name => "index_invitations_on_token", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_limit",  :default => 5
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
