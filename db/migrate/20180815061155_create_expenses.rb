class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :default_id
      t.date :use_date
      t.integer :amount
      t.date :depatture_location
      t.date :arrival_location
      t.integer :quantity
      t.string :note
      t.integer :payment_type

      t.timestamps null: false
    end
  end
end
