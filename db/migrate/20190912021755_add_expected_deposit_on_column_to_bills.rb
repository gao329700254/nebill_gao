class AddExpectedDepositOnColumnToBills < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :expected_deposit_on, :date
  end
end
