class CreateApprovalGroupUsers < ActiveRecord::Migration
  def change
    create_table :approval_group_users do |t|
      t.references :approval_group, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.references :user, null: false, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps null: false
    end
  end
end
