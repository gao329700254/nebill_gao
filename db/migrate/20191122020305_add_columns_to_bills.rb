class AddColumnsToBills < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :project_name, :string, null: false
    add_column :bills, :company_name, :string, null: false
    add_column :bills, :issue_on, :date
  end
end
