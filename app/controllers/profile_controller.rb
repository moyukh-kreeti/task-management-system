# frozen_string_literal: true

# ProfileController class
class ProfileController < ApplicationController
  before_action :current_user, :all_notifications
  def index; end

  def uploadimage
    @user = User.find_by(employee_id: session[:user_id])
    @user.image.attach(params[:user][:image])
    redirect_to profile_index_path
  end
end
