class CreateExpenseApprovalUsers < ActiveRecord::Migration
  def change
    create_table :expense_approval_users do |t|
      t.integer :expense_approval_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
