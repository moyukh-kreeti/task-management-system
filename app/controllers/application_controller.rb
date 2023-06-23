class ApplicationController < ActionController::Base
  @@welcome_flash = false
  @active_window = "home"
  helper_method :current_user

  def current_user
    @user ||= User.find_by(employee_id: session[:user_id])
  end
end
