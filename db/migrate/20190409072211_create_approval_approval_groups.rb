class CreateApprovalApprovalGroups < ActiveRecord::Migration
  def change
    create_table :approval_approval_groups do |t|
      t.references :approval, index: true, foreign_key: { on_delete: :cascade }
      t.references :approval_group, index: true, foreign_key: { on_delete: :cascade }
      t.integer :status, null: false, default: 10
      t.string :comment

      t.timestamps null: false
    end
  end
end
