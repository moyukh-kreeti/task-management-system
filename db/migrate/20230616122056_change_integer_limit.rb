class ChangeIntegerLimit < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :employee_id,:integer, limit: 8
  end
end
