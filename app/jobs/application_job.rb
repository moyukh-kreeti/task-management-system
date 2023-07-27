# frozen_string_literal: true

# ApplicationJob class
class ApplicationJob < ActiveJob::Base
  def send_notification(current_user, id, msg)
    user = User.find_by(employee_id: id)
    user.notification.create(sender_id: current_user.id, message: msg, read_status: false)
    user.save
    ActionCable.server.broadcast("notification_for_#{id}", { message: msg })
  end

  def send_reminder(id, msg)
    user = User.find_by(employee_id: id)
    user.notification.create(message: msg, read_status: false)
    user.save!
    ActionCable.server.broadcast("notification_for_#{id}", { message: msg })
  end
end
