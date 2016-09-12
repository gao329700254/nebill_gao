class CreateProjectFileGroups < ActiveRecord::Migration
  def change
    create_table :project_file_groups do |t|
      t.integer  :project_id, null: false
      t.string   :name      , null: false

      t.timestamps null: false
    end

    add_column :project_files, :file_group_id, :integer, null: true
  end
end
