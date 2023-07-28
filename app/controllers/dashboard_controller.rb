# frozen_string_literal: true

# DashboardController class
class DashboardController < ApplicationController
  include ApplicationHelper
  include DashboardHelper

  before_action :current_user
  before_action :check_session, except: [:index]
  before_action :all_notifications, except: [:index]

  def index
    redirect_to authentication_login_path unless session[:user_id].present?
    return unless session[:user_id].present?

    @user = User.find_by(employee_id: session[:user_id])
    redirect_to dashboard_mytask_path
  end

  def mytask
    @active_window = 'mytask'
    @assigned_mytasks = assigned_tasks
    @working_mytasks = working_tasks
    @completed_mytasks = completed_tasks
  end

  def assigntask
    @active_window = 'assigntask'
    @task_category = TaskCategory.all.order(:task_name)
    @all_users ||= User.all.order(:name)
    @all_assigned_tasks = Task.all.where(assign_by: @user.employee_id).order(:task_approval).page(params[:page]).per(10)
  end

  def adminpanel
    @active_window = 'adminpanel'
    @total_user = User.all.count
    @all_verified_task = Task.all.where(task_approval: true).where(sended_to_hr: false)
    @all_users = User.all.page(params[:page]).order(:name).per(6)
    @all_task_categories = TaskCategory.order(:task_name)
    @all_users_with_roles = User.order(:name)
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
      format.js { render locals: { notification: @notifications } }
    end
  end
end
