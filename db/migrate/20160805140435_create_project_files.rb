class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.integer  :project_id  , null: false
      t.string   :file        , null: false

      t.timestamps null: false
    end
  end
end
