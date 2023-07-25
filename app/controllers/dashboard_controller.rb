class DashboardController < ApplicationController
  include ApplicationHelper

  before_action :current_user, :all_notifications

  def index
    redirect_to authentication_login_path unless session[:user_id].present?
    return if session[:user_id].present? == false

    @user = User.find_by(employee_id: session[:user_id])

    # @active_window = 'mytask'
    # if @@welcome_flash == false
    #   flash.now[:success] = 'Welcome user'
    #   @@welcome_flash = true
    # end
    # if session[:role] == 2
    #   render 'admin_index'
    # elsif session[:role] == 1
    #   render 'hrd_index'
    # end
    # @assigned_mytasks = @user.task.all.where(status: 0).page(params[:page]).per(3)
    # @working_mytasks = @user.task.all.where(status: 1).page(params[:page]).per(3)
    # @completed_mytasks = @user.task.all.where(status: 2).page(params[:page]).per(3)
    # render 'mytask'
    redirect_to dashboard_mytask_path
  end

  def mytask
    @active_window = 'mytask'
    @assigned_mytasks = @user.task.all.where(status: 0).page(params[:page]).per(3)
    @working_mytasks = @user.task.all.where(status: 1).page(params[:page]).per(3)
    @completed_mytasks = @user.task.all.where(status: 2).page(params[:page]).per(3)
  end

  def assigntask
    @active_window = 'assigntask'
    @task_category = TaskCategory.all
    @all_users ||= User.all
    @all_assigned_tasks = Task.all.where(assign_by: @user.employee_id).order(:task_approval).page(params[:page]).per(10)
    puts @all_assigned_tasks
  end

  def adminpanel
    @active_window = 'adminpanel'
    @total_user = User.all.count
    @all_verified_task = Task.all.where(task_approval: true).where(sended_to_hr: false)
    @all_users = User.all.page(params[:page]).per(6)
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
