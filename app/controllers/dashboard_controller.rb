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
  end

  def assigntask
    @active_window="assigntask"
    @task_category=TaskCategory.all
    @all_users||=User.all
  end

  def adminpanel
    @active_window="adminpanel"
    @total_user=User.all.count
    @total_task=Task.all.count
    @all_users||=User.all
    @all_task_categories=TaskCategory.all
  end

  

end
