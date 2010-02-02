class UsersController < ApplicationController
  skip_before_filter :store_location, :only => [:new, :create]
  before_filter :require_no_login, :only => [:new, :create]
  before_filter :login_required, :only => [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "You have successfully registered."
      redirect_to root_url
    else
      render :action => :new
    end
  end
  
end
