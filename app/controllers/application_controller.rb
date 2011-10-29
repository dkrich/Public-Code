# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  helper_method :current_user_session, :current_user, :is_admin, :require_admin
  
  private
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to :controller => "users", :action => "index"
      return false
    end
  end
  
  def is_admin(user)
    if user.admin == 1
      return true
    else
      return false
    end
  end
  
  def require_admin
    if current_user
      unless is_admin(current_user)
        redirect_to :controller => "users", :action => "show"
        return false
      end
    else
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def get_next_weekday(date)
    if date.include?("Sat")
      return date + 2.days
    elsif date.include?("Sun")
      return date + 1.day
    else
      return date
    end
  end

  def redirect_to(options = {}, response_status = {})
    if request.xhr?
      render(:update) {|page| page.redirect_to(options)}
    else
      super(options, response_status)
    end
  end

end
