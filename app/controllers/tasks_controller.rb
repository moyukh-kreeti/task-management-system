class TasksController < ApplicationController

  before_action :current_user
  helper_method :change_task_status

  def create

    @task_user=User.find(task_params[:assign_to].to_i)
    # binding.pry
    date_time= DateTime.parse(task_params[:task_date]+"T"+task_params[:task_time])
    @task=@task_user.task.create(
      task_name: task_params[:task_name],
      task_category: TaskCategory.find(task_params[:task_category]),
      assign_by: @user.employee_id,
      task_importance: task_params[:task_importance].to_i,
      task_date: date_time,
      task_time:date_time,
      repeat_interval:task_params[:notification_interval].to_i,
      status:0
    )

    sub_tasks=task_params[:sub_task]

    sub_tasks.each do |_key,value|

      @task.sub_tasks.create(name: value,status:0)

    end


    respond_to do |format|
      format.js
    end

  end

  def show
    @active_window="assigntask"
    @task=Task.find(params[:id])
    @sub_tasks=@task.sub_tasks.all
  end

  def edit
    @active_window="assigntask"
  end

  def destroy
    @task=Task.find(params[:id])
    @task.destroy
    redirect_to dashboard_assigntask_path
  end

  def update

  end


  def change_task_status

    # task=User.find(39).task.find(params[:task_data][:id].to_i)
    # puts check_subtask_status(task)

    task=User.find(39).task.find(params[:task_data][:id].to_i)

    remain_count=task.sub_tasks.all.where(status:0).or(task.sub_tasks.all.where(status:1)).count

    respond_to do |format| 
      format.js { render locals: { remain_count: remain_count } }
    end
    
  end


  def check_subtask_status(task)

    task.sub_tasks.all.each do |sub_task|
      if sub_task.status_for_database ==0||sub_task.status_for_database  ==1
        return false
      end
    end

    return true

  end



  def task_params
    params.require(:task_data).permit(:task_name,:task_category,:task_date,:task_time,:notification_interval,:assign_to,:task_importance, sub_task: {})
  end
end
