require 'httparty'
class AuthenticationController < ApplicationController
  def login

  end

  def create
    user_info = request.env['omniauth.auth']
    @user=User.find_by_email(user_info.info.email)
    if @user
      flash[:success] = "Welcome User"
      binding.pry
      @user.employee_id=user_info.uid
      @user.save
      session[:user_id] = @user.employee_id
      session[:role]=@user.roles_for_database
      session[:access_token]=user_info.credentials.token
      # SessionTimeoutJob.set(wait: 10.seconds).perform_later(@user)
      # WelcomeMailer.with(to: @user.email,user:@user).welcome.deliver_later
      redirect_to root_path
    else
      flash[:danger] = "You are not authorized to login"
      puts "You are not authorized to login"
      render "login"
    end
  end


  def logout
    puts "-----------------------------------------------------"
    puts "Logout"
    response = HTTParty.get("https://accounts.google.com/o/oauth2/revoke?token="+session[:access_token].to_s)
    # if response.code==200
    #   reset_session
    # end
    reset_session
    @@welcome_flash = false
    redirect_to root_path

  end
  
end
