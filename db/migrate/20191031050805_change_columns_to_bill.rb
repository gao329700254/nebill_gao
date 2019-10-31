class ChangeColumnsToBill < ActiveRecord::Migration[5.0]
  def up
    change_column :bills, :payment_type, :string, null: false
    change_column :bills, :bill_on, :date, null: false
    change_column :bills, :expected_deposit_on, :date, null: false
  end

  def down
    change_column :bills, :payment_type, :string, null: true
    change_column :bills, :bill_on, :date, null: true
    change_column :bills, :expected_deposit_on, :date, null: true
  end
end
