class AddMemoToBills < ActiveRecord::Migration
  def change
    add_column :bills, :memo, :text, null: true
  end
end
