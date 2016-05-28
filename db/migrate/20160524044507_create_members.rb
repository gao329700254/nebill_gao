class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :employee_id, null: false
      t.integer :project_id , null: false
    end
    add_index :members, [:employee_id, :project_id], unique: true
    add_index :members, [:project_id]
  end
end
