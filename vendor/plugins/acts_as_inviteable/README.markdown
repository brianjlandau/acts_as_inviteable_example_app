acts\_as\_inviteable
================

A simple to use plugin for creating an invite system for an app.


### Generator

The normal workflow is to have a user model already created and then
use the generator to get started:

    script/generate invitations_for User
    
This will add 2 routes to your routes file (`config/routes.rb`) you may wish to edit these:

    map.resource :invitation, :only => [:new, :create]
    map.signup   '/signup/:invite_code', :controller => 'users', :action => 'new'
    
It will also add `acts_as_inviteable` to your `User` model.

After running the generator you need to run `rake db:migrate` to add the invitations table and invitation_limit column.

#### Without an existing User model

When running the generator add the `--create-user-model` flag to the command:

    script/generate invitations_for --create-user-model User

You then will need to customize the migration created for the User model before running `rake db:migrate`.


### Options

By default users are allowed to invite 5 others. You can customize this by providing an option to `acts_as_inviteable`.  
Change how you call `acts_as_inviteable` in your users model by adding the `default_invitation_limit` option:

    acts_as_inviteable :default_invitation_limit => 20


Copyright (c) 2009 Brian Landau (Viget Labs), released under the MIT license
