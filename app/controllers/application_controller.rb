class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login

  helper_method :current_user
  helper_method :logged_in?

  include Serialized

  def current_user
    @current_user ||= (session[:username] || cookies[:username])
  end

  def logged_in?
    current_user.present?
  end

  protected

  def require_login
    redirect_to(login_path) unless logged_in?
  end
end
