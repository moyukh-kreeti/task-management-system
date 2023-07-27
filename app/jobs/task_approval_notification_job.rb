# frozen_string_literal: true

# TaskApprovalNotificationJob class
class TaskApprovalNotificationJob < ApplicationJob
  queue_as :default

  def perform(task, current_user)
    msg = "Task with task name : #{task.task_name} is Approved By #{current_user.name} #{current_user.surname}"
    User.all.where(roles: 2).each do |user|
      send_notification(current_user, user.employee_id, msg)
      TaskMailer.with(to: user.email, task:, current_user:).approval_task.deliver_later
    end
  end
end
