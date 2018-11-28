class AddProjectToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :project_id, :integer
    add_foreign_key :expenses, :projects, column: :project_id, on_delete: :nullify
  end
end
