class NotificationChannel < ApplicationCable::Channel
  def subscribed
    puts params
    # user=User.find_by(employee_id: params[:user_id])
    # puts user.name
    stream_from "notification_for_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
