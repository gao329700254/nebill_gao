class ChangeColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :immediate_boss, :integer
    add_foreign_key :users, :users, column: :immediate_boss, on_delete: :nullify
  end
end
