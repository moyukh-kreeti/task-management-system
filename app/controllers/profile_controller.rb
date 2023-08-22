# frozen_string_literal: true

# ProfileController class
class ProfileController < ApplicationController
  before_action :check_session, :current_user, :all_notifications, :all_notifications_type
  def index; end

  def uploadimage
    @user = User.find_by(employee_id: session[:user_id])
    # @user.image.attach!(params[:user][:image])
    @user.image = params[:user][:image]
    if @user.save(validate: false)
      puts 'Image uploaded successfully!'
    else
      puts 'Error uploading image'
    end
    redirect_to profile_index_path
  end
end
