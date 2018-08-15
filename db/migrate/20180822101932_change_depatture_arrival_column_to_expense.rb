class ChangeDepattureArrivalColumnToExpense < ActiveRecord::Migration
  def up
    change_table :expenses do |t|
      t.change :depatture_location, :string
      t.change :arrival_location, :string
    end
  end

  def down
    change_table :expenses do |t|
      t.change :depatture_location, :date
      t.change :arrival_location, :date
    end
  end
end
