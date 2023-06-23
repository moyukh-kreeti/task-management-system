class AddColumnAssignByToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :assign_by, :string
  end
end
