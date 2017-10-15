class AddBillToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :bill_id, :integer
  end
end
