class RemoveColumnFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :contractual_coverage, :string
  end
end
