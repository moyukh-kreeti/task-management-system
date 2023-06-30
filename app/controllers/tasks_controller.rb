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

    # Usser.find will be replaced with current user
    task=User.find(39).task.find(params[:task_data][:id].to_i)

    remain_count=task.sub_tasks.all.where(status:0).or(task.sub_tasks.all.where(status:1)).count
    status=params[:task_data][:status].to_i
    fn_st=false

    if status == 2 && remain_count>0
     fn_st=true 
    else  
      task.status=2   
    end

    if status == 0
      task.status=0
    elsif  status == 1
      task.status=1 
    end

    task.save

    respond_to do |format| 
      format.js { render locals: { final_status: fn_st,task: task} }
    end
  end

  def change_subtask_status
    sub_task=SubTask.find(params[:subtask_data][:id].to_i)
    sub_task.status=params[:subtask_data][:status].to_i
    stt=sub_task.task
    final_status=false
    if params[:subtask_data][:status].to_i==1 && stt.status_for_database==0
      stt.status=1
      stt.save
      final_status=true
    end
    sub_task.save
    respond_to do |format| 
      format.js { render locals: { final_status: final_status,task: stt,sub_task: sub_task} }
    end
  end


  def apply_filters

    puts params

    identify=params[:filters][:identify]
    day=params[:filters][:day].present? ? params[:filters][:day].to_i : 1
    priority=params[:filters][:priority].present? ? params[:filters][:priority].to_i : 3

    _day=Date.today
    if day==0
      _day=Date.tomorrow
    elsif day==2
      _day=Date.yesterday
    end

    if identify=="assigned"
      mytasks=User.find(39).task.all.where(status:0)
    elsif identify=="working"
      mytasks=User.find(39).task.all.where(status:1)
    else
      mytasks=User.find(39).task.all.where(status:2)
    end

    if day!=3
      mytasks=mytasks.where("DATE(task_date) = ?", _day)
    end

    if priority!=3
      mytasks=mytasks.where(task_importance:priority)
    end


    respond_to do |format| 
      format.js { render locals: { identification: identify,task: mytasks} }
    end

    
    # @working_mytasks=User.find(39).task.all.where(status:1)
    # @completed_mytasks=User.find(39).task.all.where(status:2)

  end




  def task_params
    params.require(:task_data).permit(:task_name,:task_category,:task_date,:task_time,:notification_interval,:assign_to,:task_importance, sub_task: {})
  end
end
