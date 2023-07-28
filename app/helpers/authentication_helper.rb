# frozen_string_literal: true

# AuthenticationController class
module AuthenticationHelper
  def find_or_create_user(user_info)
    user = User.find_by_email(user_info.info.email)
    if user
      user.update_columns(employee_id: user_info.uid)
    else
      flash[:danger] = 'You are not authorized to login'
    end

    user
  end

  def handle_successful_login(user_info)
    flash[:success] = 'Welcome User'
    session[:user_id] = @user.employee_id
    session[:role] = @user.roles_for_database
    session[:access_token] = user_info.credentials.token
  end

  def handle_failed_login
    render 'login'
  end
end
