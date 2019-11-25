class AddColumnsToBill < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :expense, :integer, null: false, default: 0
    add_column :bills, :require_acceptance, :boolean, default: true
  end
end
