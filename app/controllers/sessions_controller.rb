class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  skip_after_action :broadcast_changes

  def new
    @session_form = SessionForm.new(username: Faker::Internet.user_name)
  end

  def create
    @session_form = SessionForm.new(session_params)
    if @session_form.valid?
      reset_session
      session[:username] = @session_form.username
      cookies.signed[:username] = { value: @session_form.username, domain: :all }
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    reset_session
    cookies.delete(:username)
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session_form).permit(:username)
  end
end
