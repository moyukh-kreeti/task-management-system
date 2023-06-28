class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :task_category , foreign_key: "task_category_id"
  has_many :sub_tasks , dependent: :destroy

  enum task_importance:{
    Low: 0,
    Medium: 1,
    High: 2
  }
end
