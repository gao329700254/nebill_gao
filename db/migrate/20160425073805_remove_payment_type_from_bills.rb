class RemovePaymentTypeFromBills < ActiveRecord::Migration
  def up
    remove_column :bills, :payment_type
  end

  def down
    add_column :bills, :payment_type, :string

    Bill.all.each do |bill|
      bill.payment_type = 'end_of_the_delivery_date_next_month'
      bill.save!
    end

    change_column :bills, :payment_type, :string, null: false
  end
end
