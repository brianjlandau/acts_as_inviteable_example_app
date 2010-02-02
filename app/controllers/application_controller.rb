# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :store_location
  helper_method :current_user, :logged_in?, :creative_format_form_partial
  
  layout proc{ |controller| controller.request.xhr? ? false : "application" }
  
  protected
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def logged_in?
    !current_user_session.blank?
  end

  def login_required
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
    true
  end

  def require_no_login
    if logged_in?
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end

  def store_location
    if request.request_method == :get and !request.xhr?
      session[:return_to] = request.request_uri
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
