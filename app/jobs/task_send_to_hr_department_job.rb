# frozen_string_literal: true

# TaskSendToHrDepartmentJob class
class TaskSendToHrDepartmentJob < ApplicationJob
  queue_as :default

  def perform(task, current_user)
    msg = "Task with task name : #{task.task_name} is Approved and Sent by Admin"
    User.all.where(roles: 1).each do |user|
      send_notification(current_user, user.employee_id, msg)
      TaskMailer.with(to: user.email, task:).send_to_hr.deliver_later
    end
  end
end
