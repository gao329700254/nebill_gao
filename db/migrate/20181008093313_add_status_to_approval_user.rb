class AddStatusToApprovalUser < ActiveRecord::Migration
  def change
    add_column :expense_approval_users, :status, :string
    add_column :expense_approval_users, :comment, :string
  end
end
