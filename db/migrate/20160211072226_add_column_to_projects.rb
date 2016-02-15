class AddColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :contractual_coverage, :string
    add_column :projects, :is_using_ses, :boolean
  end
end
