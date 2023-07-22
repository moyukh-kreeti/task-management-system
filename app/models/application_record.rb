class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  enum status: {
    Assigned: 0,
    Working: 1,
    Completed: 2
  }

  # def send_notification(current_user, id, msg)
  #   user = User.find_by(employee_id: id)
  #   user.notification.create(sender_id: current_user.id, message: msg, read_status: false)
  #   user.save
  #   ActionCable.server.broadcast("notification_for_#{id}", { message: msg })
  # end
end
