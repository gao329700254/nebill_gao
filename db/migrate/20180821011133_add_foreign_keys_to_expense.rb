class AddForeignKeysToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :created_user_id, :integer
    add_foreign_key :expense_files, :expenses, column: :expense_id, on_delete: :nullify
    add_foreign_key :expenses, :users, column: :created_user_id, on_delete: :nullify
    add_foreign_key :expense_groups, :expenses, column: :expense_id, on_delete: :nullify
    add_foreign_key :expense_groups, :expense_approvals, column: :expense_approval_id, on_delete: :nullify
    add_foreign_key :expense_approvals, :users, column: :created_user_id, on_delete: :nullify
    add_foreign_key :expense_approval_users, :expense_approvals, column: :expense_approval_id, on_delete: :nullify
    add_foreign_key :expense_approval_users, :users, column: :user_id, on_delete: :nullify
  end
end
