class AddGroupIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :group_id, :integer, null: true
  end
end
