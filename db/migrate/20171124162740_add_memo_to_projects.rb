class AddMemoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :memo, :text
  end
end
