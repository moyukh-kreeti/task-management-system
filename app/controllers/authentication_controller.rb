# frozen_string_literal: true

require 'httparty'
# AuthenticationController class
class AuthenticationController < ApplicationController
  include AuthenticationHelper

  def login; end

  def create
    user_info = request.env['omniauth.auth']
    @user = find_or_create_user(user_info)
    if @user
      handle_successful_login(user_info)
      WelcomeMailer.with(to: @user.email, user: @user).welcome.deliver_later
      redirect_to root_path
    else
      handle_failed_login
    end
  end

  def logout
    HTTParty.get("https://accounts.google.com/o/oauth2/revoke?token=#{session[:access_token]}")
    reset_session
    # @@welcome_flash = false
    redirect_to root_path
  end

  def add_admin_user
    return unless session[:user_id]

    redirect_to root_path
  end

  def add_user
    @user = User.create(name: people_params[:fname], surname: people_params[:lname], email: people_params[:email],
                        roles: 2)
    flag = false
    flag = true if @user
    respond_to do |format|
      format.json { render json: { status: flag } }
    end
  end

  def people_params
    params.require(:info).permit(:fname, :lname, :email)
  end
end
