class CreateApprovalUsers < ActiveRecord::Migration
  def change
    create_table :approval_users do |t|
      t.integer :approval_id
      t.integer :user_id
      t.integer :status

      t.timestamps null: false
    end
    add_index :approval_users, :approval_id
    add_index :approval_users, :user_id
    add_index :approval_users, [:approval_id, :user_id], unique: true
  end
end
