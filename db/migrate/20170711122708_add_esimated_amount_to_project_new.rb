class AddEsimatedAmountToProjectNew < ActiveRecord::Migration
  def change
    add_column :projects, :estimated_amount, :integer
  end
end
