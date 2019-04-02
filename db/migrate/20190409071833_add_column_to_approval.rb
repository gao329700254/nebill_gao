class AddColumnToApproval < ActiveRecord::Migration
  def change
    add_column :approvals, :approvaler_type, :integer, null: false, default: 10
  end
end
