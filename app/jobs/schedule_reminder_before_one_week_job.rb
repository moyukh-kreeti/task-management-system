class ScheduleReminderBeforeOneWeekJob < ApplicationJob
  queue_as :default

  def perform(current_user, task_user, task)
    return unless task.Completed?

    send_notification(current_user, task_user.employee_id,
                      "Your task with task name: #{task.task_name} is still need to be done")
  end
end
