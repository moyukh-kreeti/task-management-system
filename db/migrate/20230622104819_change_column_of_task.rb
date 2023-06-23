class ChangeColumnOfTask < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :task_category,:integer,using: "task_category::integer"
  end
end
