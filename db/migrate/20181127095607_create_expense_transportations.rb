class CreateExpenseTransportations < ActiveRecord::Migration
  def change
    create_table :expense_transportations do |t|
      t.integer :amount
      t.string :departure
      t.string :arrival

      t.timestamps null: false
    end
  end
end
