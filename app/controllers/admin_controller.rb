class AdminController < ApplicationController
  before_action :current_user

  def addUser
    @user = User.create(name: people_params[:fname], surname: people_params[:lname], email: people_params[:email],
                        roles: people_params[:roles].to_i)
    @total_user = User.all.count
    respond_to do |format|
      format.js
    end
  end

  def makeAdmin
    if @user.Admin?
      emp = User.find(params[:id])
      emp.roles = 2
      emp.save!
    end

    respond_to do |format|
      format.js
    end
  end

  def makeHr
    if @user.Admin?
      emp = User.find(params[:id])
      emp.roles = 1
      emp.save!
    end

    respond_to do |format|
      format.js
    end
  end

  def addTaskCategories
    @task_category = TaskCategory.create(task_name: params[:data])

    respond_to do |format|
      format.js
    end
  end

  def removeTaskCategories
    TaskCategory.find(params[:id]).destroy
    respond_to do |format|
      format.js
    end
  end

  def send_to_hr
    task = Task.find(params[:id])
    task.sended_to_hr = true
    task.save
    TaskSendToHrDepartmentJob.perform_later(task, current_user)
    respond_to do |format|
      format.js { render locals: { task: } }
    end
  end

  def people_params
    params.require(:info).permit(:fname, :lname, :email, :roles)
  end
end
