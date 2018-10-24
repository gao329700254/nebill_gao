class AddReceiptIsDefaultExpenseItems < ActiveRecord::Migration
  def change
    add_column :default_expense_items, :is_receipt, :boolean
  end
end
