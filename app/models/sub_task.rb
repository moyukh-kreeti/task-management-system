# frozen_string_literal: true

# Subtask Model
class SubTask < ApplicationRecord
  belongs_to :task
  after_create :create_sub_uid

  def create_sub_uid
    self.uid = format('SubTask_%<taskuid>s%<sub_task_id>04d', taskuid: task.uid[5..], sub_task_id: id)
    save
  end
end
