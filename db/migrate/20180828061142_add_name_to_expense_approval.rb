class AddNameToExpenseApproval < ActiveRecord::Migration
  def change
    add_column :expense_approvals, :name, :string
  end
end
