class CreateExpenseApprovals < ActiveRecord::Migration
  def change
    create_table :expense_approvals do |t|
      t.integer :total_amount
      t.string :note
      t.integer :status
      t.integer :created_user_id
      t.integer :expenses_number

      t.timestamps null: false
    end
  end
end
