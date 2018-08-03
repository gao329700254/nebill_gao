class AddStatusToApproval < ActiveRecord::Migration
  def change
    add_column :approvals, :status, :integer
  end
end
