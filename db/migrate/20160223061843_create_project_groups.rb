class CreateProjectGroups < ActiveRecord::Migration
  def change
    create_table :project_groups do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
