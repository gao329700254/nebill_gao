class AddDefaultStatusToExpenseApproval < ActiveRecord::Migration[5.0]
  def up
    change_column :expense_approvals, :status, :integer, null: false, default: 10
  end

  def down
    change_column :expense_approvals, :status, :integer, null: true, default: nil
  end
end
