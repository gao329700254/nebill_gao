class AddIsPresidentColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_chief, :boolean, default: false
  end
end
