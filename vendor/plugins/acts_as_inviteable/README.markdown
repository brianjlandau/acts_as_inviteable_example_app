acts\_as\_inviteable
================

A simple to use plugin for creating an invite system for an app.

### Installing

Go to the root directory of your rails app and run this command:

    script/plugin install git://github.com/vigetlabs/acts_as_inviteable.git


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


### What it gives you

#### On the Invite Model:

* Validates necessary attributes on the Invitation, including email address format.
* Makes sure an invite hasn't already been sent to the `recipient_email` by validating it's uniqueness.
* Makes sure the recipient's email isn't already in the User's table.
* Makes sure the user has at least one invite left to give.
* Automatically decrements the User's `invitation_limit` when an invite they created is saved.
* Automatically sends an email to the recipient after the Invitation is saved.
* A `named_scope` called `by_created_at`
* A `named_scope` called `unaccepted` which finds all the invites that don't have users with a match for their `recipient_email`.
* Sets up `ActiveRecord` relationships for both the `sender` and the `recipient`.
* Has a `accepted?` instance method to test if the invite has been accepted or not.

#### On the Inviteable Model (User):

* Sets the `invitation_limit` on create
* Requires that the user have a valid `invitation_code` attribute or have the `invite_not_needed` attribute set to `true`.
* Automatically set the Users `email` address to the `recipient_email` field on the invite.
* Has an `ActiveRecord` relationship for `sent_invitations`, invites sent by the user.


### Example App

I've put up an example app that show's how to integrate this with your controller and view code as well as some tests for that code:  
[http://github.com/brianjlandau/acts\_as\_inviteable\_example\_app](http://github.com/brianjlandau/acts_as_inviteable_example_app)


Copyright (c) 2009 Brian Landau (Viget Labs), released under the MIT license
