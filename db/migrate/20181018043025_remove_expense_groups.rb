class RemoveExpenseGroups < ActiveRecord::Migration
  def up
    remove_foreign_key :expense_groups, :expenses
    remove_foreign_key :expense_groups, :expense_approvals

    drop_table :expense_groups

    add_column :expenses, :expense_approval_id, :integer 

    add_foreign_key :expenses, :expense_approvals, on_delete: :nullify
  end
  
  def down

    remove_foreign_key :expenses, :expense_approvals
    remove_column :expenses, :expense_approval_id

    create_table :expense_groups do |t|
      t.integer :expense_id
      t.integer :expense_approval_id

      t.timestamps null: false
    end

    add_foreign_key :expense_groups, :expenses, column: :expense_id, on_delete: :nullify
    add_foreign_key :expense_groups, :expense_approvals, column: :expense_approval_id, on_delete: :nullify
  end
end
