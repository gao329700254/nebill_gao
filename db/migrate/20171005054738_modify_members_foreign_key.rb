class ModifyMembersForeignKey < ActiveRecord::Migration
  def up
    remove_foreign_key :members, :projects
    remove_index :members, [:project_id]
    remove_column :members, :project_id
    add_column :members, :bill_id, :integer, null: false
    add_foreign_key :members, :bills, on_delete: :cascade
    add_index :members, [:bill_id]
    add_index :members, [:employee_id, :bill_id], unique: true
  end

  def down
    remove_foreign_key :members, :bills
    remove_index :members, [:bill_id]
    remove_index :members, [:employee_id]
    remove_column :members, :bill_id
    add_column :members, :project_id, :integer, null: false
    add_foreign_key :members, :projects, on_delete: :cascade
    add_index :members, [:employee_id, :project_id], unique: true
    add_index :members, [:project_id]
  end
end
