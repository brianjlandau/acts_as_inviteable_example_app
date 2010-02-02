# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_acts_as_inviteable_example_app_session',
  :secret      => 'fb0c2926e49aed8d0444ea16fb009a5cb5a76bac574c5c0baf4d7fd3cd2e52875e664cadf6f5bd1cd9b581243b2270219c096a1fd76bd2430112d8c8a6bf075f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
