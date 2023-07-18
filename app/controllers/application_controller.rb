class ApplicationController < ActionController::Base
  @@welcome_flash = false
  @active_window = 'home'
  helper_method :current_user

  def current_user
    @user ||= User.find_by(employee_id: session[:user_id])
  end

  def all_notifications
    @notifications ||= @user.notification.all.where(read_status: false)
  end

  def all_task_status
    @task_status = {
      'assigned' => 0,
      'working' => 1,
      'completed' => 2
    }
  end
end
