class DashboardController < ApplicationController

  before_action :current_user

  def index
    if(!session[:user_id].present?)
      redirect_to authentication_login_path
    end
    @user=User.find_by(employee_id:session[:user_id])
    
    @active_window="home"
    if (@@welcome_flash==false)
      flash.now[:success] = "Welcome user"
      @@welcome_flash = true
    end
    if(session[:role]==2)
      render "admin_index"
    elsif(session[:role]==1)
      render "hrd_index"
    end
  end


  def mytask
    @active_window="mytask"

    # There will be some changes here @current user will be used
    @assigned_mytasks=User.find(39).task.all.where(status:0)
    @working_mytasks=User.find(39).task.all.where(status:1)
    @completed_mytasks=User.find(39).task.all.where(status:2)

  end

  def assigntask
    @active_window="assigntask"
    @task_category=TaskCategory.all
    @all_users||=User.all

    @all_assigned_tasks=Task.all.where(assign_by: @user.employee_id)
    puts "--------------------------------------------"
    puts @all_assigned_tasks

  end

  def adminpanel
    @active_window="adminpanel"
    @total_user=User.all.count
    @total_task=Task.all.count
    @all_users||=User.all
    @all_task_categories=TaskCategory.all
  end

  

end
