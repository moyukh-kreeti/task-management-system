class DashboardController < ApplicationController
  include ApplicationHelper

  before_action :current_user, :all_notifications

  def index
    redirect_to authentication_login_path unless session[:user_id].present?
    @user = User.find_by(employee_id: session[:user_id])

    @active_window = 'home'
    if @@welcome_flash == false
      flash.now[:success] = 'Welcome user'
      @@welcome_flash = true
    end
    if session[:role] == 2
      render 'admin_index'
    elsif session[:role] == 1
      render 'hrd_index'
    end
  end

  def mytask
    @active_window = 'mytask'
    @assigned_mytasks = @user.task.all.where(status: 0)
    @working_mytasks = @user.task.all.where(status: 1)
    @completed_mytasks = @user.task.all.where(status: 2)
  end

  def assigntask
    @active_window = 'assigntask'
    @task_category = TaskCategory.all
    @all_users ||= User.all
    @all_assigned_tasks = Task.all.where(assign_by: @user.employee_id)
    puts @all_assigned_tasks
  end

  def adminpanel
    @active_window = 'adminpanel'
    @total_user = User.all.count
    @all_verified_task = Task.all.where(task_approval: true).where(sended_to_hr: false)
    @all_users ||= User.all
    @all_task_categories = TaskCategory.all
  end

  def hrpanel
    @active_window = 'hrpanel'
    @all_sended_task = Task.all.where(sended_to_hr: true)
  end

  def mark_all_read
    @notifications.each do |item|
      item.read_status = true
      item.save
    end

    respond_to do |format|
      format.js
    end
  end
end
