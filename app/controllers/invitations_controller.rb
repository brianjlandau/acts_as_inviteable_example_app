class InvitationsController < ApplicationController
  before_filter :login_required

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(params[:invitation].merge(:sender => current_user))
    if @invitation.save
      flash[:notice] = "Thank you, the invitation has been sent."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

end