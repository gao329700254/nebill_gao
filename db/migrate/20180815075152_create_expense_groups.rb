class CreateExpenseGroups < ActiveRecord::Migration
  def change
    create_table :expense_groups do |t|
      t.integer :expense_id
      t.integer :expense_approval_id

      t.timestamps null: false
    end
  end
end
