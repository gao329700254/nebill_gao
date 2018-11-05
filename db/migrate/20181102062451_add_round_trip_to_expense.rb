class AddRoundTripToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :is_round_trip, :boolean, default: false
  end
end
