class AddTypeToApprovals < ActiveRecord::Migration
  def change
    add_column :approvals, :category, :integer
  end
end
