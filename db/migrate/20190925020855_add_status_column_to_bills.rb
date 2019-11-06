class AddStatusColumnToBills < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :status, :integer, null: false, default: 10
  end
end
