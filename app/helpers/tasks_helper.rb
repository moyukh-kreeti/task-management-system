# frozen_string_literal: true

# TasksHelper module
module TasksHelper
  def parse_date_time(date, time)
    DateTime.parse("#{date}T#{time}")
  end

  def create_task(date_time)
    @task_user.task.create(task_name: task_params[:task_name],
                           task_category: TaskCategory.find(task_params[:task_category]),
                           assign_by: @user.employee_id, task_importance: task_params[:task_importance].to_i,
                           task_date: date_time, task_time: date_time,
                           description: task_params[:task_des],
                           repeat_interval: task_params[:notification_interval].to_i, status: 0)
  end

  def create_sub_tasks(sub_tasks_params)
    sub_tasks_params.each do |_key, value|
      @task.sub_tasks.create(name: value, status: 0)
    end
  end

  def send_notification_for_task
    msg = "Task Has been assigned to you by #{current_user.name} #{current_user.surname}"
    send_notification(@task_user.employee_id, msg)
    redirect_url = root_url.chop + dashboard_mytask_path
    TaskMailer.with(to: @task_user.email, task: @task, assign_user: current_user,
                    redirect: redirect_url).create.deliver_later
  end

  def post_task_creation_work
    create_sub_tasks(task_params[:sub_task]) if task_params[:sub_task].present?
    date = Date.today + @task.interval_of_notifications[task_params[:notification_interval].to_i]
    @task.next_notification_date = date
    @task.save
    send_notification_for_task
  end

  def make_search_params
    @query = params[:search][:query]
    @status = all_task_status[params[:search][:status]]
  end

  def update_task_status(task, status)
    remain_count = task.sub_tasks.where(status: [0, 1]).count
    if status == 2 && remain_count.positive?
      true
    else
      task.status = status
      task.save
      false
    end
  end

  def find_subtask(subtask_id)
    SubTask.find(subtask_id.to_i)
  end

  def update_subtask_status(sub_task, status)
    sub_task.status = status.to_i
    sub_task.save
  end

  def update_task_status_after_subtask(task, subtask_status)
    if subtask_status.to_i == 1 && task.status_for_database.zero?
      task.status = 1
      task.save
      true
    else
      false
    end
  end

  def day_param_generator
    params[:filters][:day].present? ? params[:filters][:day].to_i : 1
  end

  def priority_generator
    params[:filters][:priority].present? ? params[:filters][:priority].to_i : 3
  end

  def calculate_day(day_param)
    case day_param
    when 0
      Date.tomorrow
    when 2
      Date.yesterday
    else
      Date.today
    end
  end

  def filter_tasks_by_identification(identify)
    if identify == 'assigned'
      @user.task.all.where(status: 0)
    elsif identify == 'working'
      @user.task.all.where(status: 1)
    else
      @user.task.all.where(status: 2)
    end
  end

  def filter_tasks_by_day(tasks, day)
    return tasks if day == 3

    tasks.where('DATE(task_date) = ?', day)
  end

  def filter_tasks_by_priority(tasks, priority)
    return tasks if priority == 3

    tasks.where(task_importance: priority)
  end
end
