class TasksController < ApplicationController
  before_action :current_user, :all_notifications
  helper_method :change_task_status
  include ApplicationHelper

  def create
    @task_user = User.find(task_params[:assign_to].to_i)
    date_time = DateTime.parse("#{task_params[:task_date]}T#{task_params[:task_time]}")
    @task = @task_user.task.create(
      task_name: task_params[:task_name],
      task_category: TaskCategory.find(task_params[:task_category]),
      assign_by: @user.employee_id,
      task_importance: task_params[:task_importance].to_i,
      task_date: date_time,
      task_time: date_time,
      description: task_params[:task_des],
      repeat_interval: task_params[:notification_interval].to_i,
      status: 0
    )
    sub_tasks = task_params[:sub_task]
    if sub_tasks.present?
      sub_tasks.each do |_key, value|
        @task.sub_tasks.create(name: value, status: 0)
      end
    end

    send_notification(@task_user.employee_id,
                      "Task Has been assigned to you by #{current_user.name} #{current_user.surname}")
    redirect_url = root_url.chop + dashboard_mytask_path
    TaskMailer.with(to: @task_user.email, task: @task, assign_user: current_user,
                    redirect: redirect_url).create.deliver_later

    respond_to do |format|
      format.js
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
  end

  def add_attachments
    task = Task.find(params[:id])
    task.attachments.attach(params[:task][:attachments])
    task.save
    redirect_to edit_task_path(task)
  end

  def search
    query = params[:search][:query]
    status = all_task_status[params[:search][:status]]
    records = Task.search_tasks(query, status, current_user.id)
    respond_to do |format|
      format.js { render locals: { records:, status: params[:search][:status] } }
    end
  end

  def change_task_status
    # Usser.find will be replaced with current user
    task = @user.task.find(params[:task_data][:id].to_i)

    remain_count = task.sub_tasks.all.where(status: 0).or(task.sub_tasks.all.where(status: 1)).count
    status = params[:task_data][:status].to_i
    fn_st = false

    if status == 2 && remain_count > 0
      fn_st = true
    else
      task.status = 2
    end

    if status == 0
      task.status = 0
    elsif status == 1
      task.status = 1
    end

    task.save

    respond_to do |format|
      format.js { render locals: { final_status: fn_st, task: } }
    end
  end

  def change_subtask_status
    sub_task = SubTask.find(params[:subtask_data][:id].to_i)
    sub_task.status = params[:subtask_data][:status].to_i
    stt = sub_task.task
    final_status = false
    if params[:subtask_data][:status].to_i == 1 && stt.status_for_database == 0
      stt.status = 1
      stt.save
      final_status = true
    end
    sub_task.save
    respond_to do |format|
      format.js { render locals: { final_status:, task: stt, sub_task: } }
    end
  end

  def apply_filters
    puts params

    identify = params[:filters][:identify]
    day = params[:filters][:day].present? ? params[:filters][:day].to_i : 1
    priority = params[:filters][:priority].present? ? params[:filters][:priority].to_i : 3

    _day = Date.today
    if day == 0
      _day = Date.tomorrow
    elsif day == 2
      _day = Date.yesterday
    end

    mytasks = if identify == 'assigned'
                @user.task.all.where(status: 0)
              elsif identify == 'working'
                @user.task.all.where(status: 1)
              else
                @user.task.all.where(status: 2)
              end

    mytasks = mytasks.where('DATE(task_date) = ?', _day) if day != 3

    mytasks = mytasks.where(task_importance: priority) if priority != 3

    respond_to do |format|
      format.js { render locals: { identification: identify, task: mytasks } }
    end

    # @working_mytasks=User.find(39).task.all.where(status:1)
    # @completed_mytasks=User.find(39).task.all.where(status:2)
  end

  def task_params
    params.require(:task_data).permit(:task_name, :task_category, :task_date, :task_des, :task_time, :task_attachments,
                                      :notification_interval, :assign_to, :task_importance, sub_task: {})
  end

  def update_params
    params.require(:task).permit(:task_date, :task_time, :attachments)
  end
end
