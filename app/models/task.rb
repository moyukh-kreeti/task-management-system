class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_categories
end
