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
end
