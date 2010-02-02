class UserSessionsController < ApplicationController
  skip_before_filter :store_location
  before_filter :require_no_login, :only => [:new, :create]
  before_filter :login_required, :only => [:destroy]
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      flash[:notice] = 'Welcome Back!'
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    session[:return_to] = nil
    redirect_to login_url
  end

end
