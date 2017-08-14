class AddRegularContractToProject < ActiveRecord::Migration
  def change
    add_column :projects, :is_regular_contract, :boolean
  end
end
