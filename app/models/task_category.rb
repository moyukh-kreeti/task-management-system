class TaskCategory < ApplicationRecord
  has_many :tasks, dependent: :destroy
end
