# frozen_string_literal: true

# ApplicationController class
# rubocop:disable all
class ApplicationController < ActionController::Base
  @@welcome_flash = false
  @active_window = 'home'
  helper_method :current_user

  def current_user
    @user ||= User.find_by(employee_id: session[:user_id])
  end

  def check_session
    if session[:user_id] == nil
      redirect_to root_path
    end
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
# rubocop:enable all
