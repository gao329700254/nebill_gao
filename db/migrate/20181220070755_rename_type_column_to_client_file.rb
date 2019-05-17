class RenameTypeColumnToClientFile < ActiveRecord::Migration
  def change
    rename_column :client_files, :type, :file_type
  end
end
