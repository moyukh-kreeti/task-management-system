# frozen_string_literal: true

# DashboardHelper module
module DashboardHelper
  def assigned_tasks
    @user.task.where(status: 0).order('DATE(task_date) ASC').order(task_importance: :desc).page(params[:page]).per(3)
  end

  def working_tasks
    @user.task.where(status: 1).order('DATE(task_date) ASC').order(task_importance: :desc).page(params[:page]).per(3)
  end

  def completed_tasks
    @user.task.where(status: 2).order('DATE(task_date) ASC').order(task_importance: :desc).page(params[:page]).per(3)
  end
end
