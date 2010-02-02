class <%= class_name %>InvitationMailer < ActionMailer::Base
  
  def invitation(invite)
    subject    "You've been sent an invitation to try out [SITE NAME]"
    recipients invite.recipient_email
    from       invite.sender.email
    sent_on    Time.current
    body       :invite => invite
  end

end
