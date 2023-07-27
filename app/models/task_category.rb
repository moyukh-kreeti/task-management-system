# frozen_string_literal: true

# TaskCategory Model
class TaskCategory < ApplicationRecord
  validates :task_name, presence: true
  has_many :tasks, dependent: :destroy
end
