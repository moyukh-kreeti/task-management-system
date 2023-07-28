# frozen_string_literal: true

# AdminController class
class AdminController < ApplicationController
  before_action :check_session, :current_user

  def add_user
    @user = User.create(name: people_params[:fname], surname: people_params[:lname], email: people_params[:email],
                        roles: people_params[:roles].to_i)
    @total_user = User.all.count
    respond_to(&:js)
  end

  def make_admin
    if @user.Admin?
      emp = User.find(params[:id])
      emp.roles = 2
      emp.save!
    end
    respond_to(&:js)
  end

  def make_hr
    if @user.Admin?
      emp = User.find(params[:id])
      emp.roles = 1
      emp.save!
    end
    respond_to(&:js)
  end

  def add_task_categories
    @task_category = TaskCategory.create(task_name: params[:data])

    respond_to(&:js)
  end

  def remove_task_categories
    TaskCategory.find(params[:id]).destroy
    respond_to(&:js)
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

  def search_user
    result = User.search_user(params[:query]).per(6)
    respond_to do |format|
      format.js { render locals: { result: } }
    end
  end

  def people_params
    params.require(:info).permit(:fname, :lname, :email, :roles)
  end
end
