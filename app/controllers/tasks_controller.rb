# frozen_string_literal: true

# TasksController class
class TasksController < ApplicationController
  before_action :check_session, :current_user, :all_notifications, :all_notifications_type
  helper_method :change_task_status, :help_method
  include ApplicationHelper
  include TasksHelper

  def create
    @task_user = User.find(task_params[:assign_to].to_i)
    date_time = parse_date_time(task_params[:task_date], task_params[:task_time])
    @task = create_task(date_time)
    post_task_creation_work
    respond_to do |format|
      format.js { render locals: { task: @task } }
    end
  end

  def show
    @active_window = 'assigntask'
    @task = Task.find(params[:id])
    @sub_tasks = @task.sub_tasks.all
  end

  def edit
    @active_window = 'assigntask'
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to dashboard_assigntask_path
  end

  def update
    task = Task.find(params[:id])
    task.update(update_params)
    task.save
    redirect_to dashboard_assigntask_path
  end

  def add_attachments
    task = Task.find(params[:id])
    task.attachments.attach(params[:task][:attachments])
    task.save
    redirect_to edit_task_path(task)
  end

  def search
    make_search_params
    records = Task.search_tasks(@query, @status, current_user.id)
    respond_to do |format|
      format.js { render locals: { records:, status: params[:search][:status] } }
    end
  end

  def change_task_status
    task = @user.task.find(params[:task_data][:id].to_i)
    status = params[:task_data][:status].to_i
    fn_st = update_task_status(task, status)
    respond_to do |format|
      format.js { render locals: { final_status: fn_st, task: } }
    end
  end

  def change_subtask_status
    sub_task = find_subtask(params[:subtask_data][:id])
    update_subtask_status(sub_task, params[:subtask_data][:status])
    stt = sub_task.task
    final_status = update_task_status_after_subtask(stt, params[:subtask_data][:status])
    respond_to do |format|
      format.js { render locals: { final_status:, task: stt, sub_task: } }
    end
  end

  def apply_filters
    identify = params[:filters][:identify]
    day_param = day_param_generator
    priority = priority_generator
    day = calculate_day(day_param)
    mytasks = filter_tasks_by_identification(identify)
    mytasks = filter_tasks_by_day(mytasks, day)
    mytasks = filter_tasks_by_priority(mytasks, priority)
    respond_to do |format|
      format.js { render locals: { identification: identify, task: mytasks } }
    end
  end

  def approve
    task = Task.find(params[:id].to_i)
    if task.status_for_database == 2
      task.task_approval = true
      task.save
      TaskApprovalNotificationJob.perform_later(task, current_user, @notifications_types[1])
    end

    respond_to do |format|
      format.js { render locals: { task: } }
    end
  end

  def task_params
    params.require(:task_data).permit(:task_name, :task_category, :task_date, :task_des, :task_time, :task_attachments,
                                      :notification_interval, :assign_to, :task_importance, sub_task: {})
  end

  def update_params
    params.require(:task).permit(:task_date, :task_time, :attachments)
  end
end
