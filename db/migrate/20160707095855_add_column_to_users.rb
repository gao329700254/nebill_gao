class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, null: false, default: 10
  end
end
