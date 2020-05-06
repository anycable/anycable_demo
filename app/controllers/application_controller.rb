class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login
  after_action :broadcast_changes, only: [:create, :destroy]

  helper_method :current_user
  helper_method :logged_in?

  include Serialized

  def current_user
    @current_user ||= (session[:username] || cookies.encrypted[:username])
  end

  def logged_in?
    current_user.present?
  end

  def broadcast_changes
    return if resource.errors.any?
    ActionCable.server.broadcast channel_name, channel_message
  end

  protected

  def require_login
    redirect_to(login_path) unless logged_in?
    gon.user_id = current_user
  end

  def channel_name
    controller_name
  end

  def channel_message
    { type: action_name, data: resource.serialized(adapter: :attributes).as_json }
  end

  def resource
    @resource ||= instance_variable_get("@#{controller_name.singularize}")
  end
end
