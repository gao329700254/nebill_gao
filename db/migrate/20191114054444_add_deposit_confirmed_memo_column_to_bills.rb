class AddDepositConfirmedMemoColumnToBills < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :deposit_confirmed_memo, :text
  end
end
