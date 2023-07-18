class ProfileController < ApplicationController
  before_action :current_user
  def index; end

  def uploadimage
    # puts params

    puts params[:user][:image]
    @user = User.find_by(employee_id: session[:user_id])
    @user.image.attach(params[:user][:image])
    redirect_to profile_index_path
  end
end
