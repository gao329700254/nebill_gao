class AddPaymentTypeOnBills < ActiveRecord::Migration
  def up
    add_column :bills, :payment_type, :string
    remove_column :bills, :payment_on
  end

  def down
    add_column :bills, :payment_on, :date, default: '9999-01-01', null: false
    remove_column :bills, :payment_type
  end
end
