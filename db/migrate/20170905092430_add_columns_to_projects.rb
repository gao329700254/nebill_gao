class AddColumnsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :status, :string
  end
end
