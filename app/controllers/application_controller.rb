class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :signed_in?
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def signed_in?
    !!current_user
  end
  
  def require_user
    access_denied unless signed_in?
  end
  
  def access_denied
    flash['danger'] = "You can't do that."
    redirect_to root_path
  end
end
