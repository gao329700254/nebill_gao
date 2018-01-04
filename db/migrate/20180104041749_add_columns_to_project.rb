class AddColumnsToProject < ActiveRecord::Migration
    
  def change
    add_column :projects, :unprocessed, :boolean, default: false
  end

end
