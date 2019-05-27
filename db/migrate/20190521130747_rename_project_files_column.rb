class RenameProjectFilesColumn < ActiveRecord::Migration
  def change
    rename_column :project_files, :type, :file_type
  end
end
