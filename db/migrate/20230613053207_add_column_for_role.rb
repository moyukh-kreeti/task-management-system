class AddColumnForRole < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :roles, :integer, default: 0
  end
end
