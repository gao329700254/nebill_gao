class AddColumnToBills < ActiveRecord::Migration
  def change
    add_column :bills, :amount, :integer, default: 0, null: false
  end
end
