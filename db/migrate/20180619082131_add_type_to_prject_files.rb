class AddTypeToPrjectFiles < ActiveRecord::Migration
  def change
    add_column :project_files, :type, :integer
  end
end
