class CreateBillApprovalUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_approval_users do |t|
      t.integer :role, null: false
      t.integer :status, default: 10, null: false
      t.string :comment
      t.references :user, null: false, foreign_key: true
      t.references :bill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
