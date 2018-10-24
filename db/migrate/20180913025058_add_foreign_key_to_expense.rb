class AddForeignKeyToExpense < ActiveRecord::Migration
  def change
    add_foreign_key :expenses, :default_expense_items, column: :default_id, on_delete: :nullify
  end
end
