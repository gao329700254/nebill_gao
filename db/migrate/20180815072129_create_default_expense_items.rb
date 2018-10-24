class CreateDefaultExpenseItems < ActiveRecord::Migration
  def change
    create_table :default_expense_items do |t|
      t.string :name
      t.string :display_name
      t.integer :standard_amount
      t.boolean :is_routing
      t.boolean :is_quantity
      t.string :note

      t.timestamps null: false
    end
  end
end
