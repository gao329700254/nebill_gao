class RemoveBillIdFromMember < ActiveRecord::Migration
  def up
    add_column :members, :project_id, :integer, null: true
    Member.all.each do |member|
      member.project_id = Bill.find(member.bill_id).project_id
      member.save! :validate => false
    end
    change_column :members, :project_id, :integer, null: false
    add_foreign_key :members, :projects, on_delete: :cascade
    add_index :members, [:project_id]
    remove_foreign_key :members, :bills
    remove_index :members, [:bill_id]
    remove_column :members, :bill_id
  end

  def down
    add_column :members, :bill_id, :integer, null: true
    Member.all.each do |member|
      member.bill_id = Bill.find_by(project_id: member.project_id).id
      member.save! :validate => false
    end
    change_column :members, :bill_id, :integer, null: false
    add_foreign_key :members, :bills, on_delete: :cascade
    add_index :members, [:bill_id]
    remove_foreign_key :members, :projects
    remove_index :members, [:project_id]
    remove_column :members, :project_id
  end
end
