class AddColumnToBills < ActiveRecord::Migration
  def change
    add_column :bills, :amount, :integer, null: false
  end
end
