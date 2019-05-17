class CreateApprovalGroups < ActiveRecord::Migration
  def change
    create_table :approval_groups do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, index: true, foreign_key: { on_delete: :nullify }

      t.timestamps null: false
    end
  end
end
