class AddOriginalFilenameToProjectFiles < ActiveRecord::Migration
  def up
    add_column :project_files, :original_filename, :string
    ProjectFile.all.each do |project_file|
      project_file.original_filename = 'sample.jpg'
      project_file.save!
    end
    change_column :project_files, :original_filename, :string, null: false
  end

  def down
    remove_column :project_files, :original_filename
  end
end
