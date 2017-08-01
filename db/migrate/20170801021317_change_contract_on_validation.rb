class ChangeContractOnValidation < ActiveRecord::Migration
  def up
    change_column :projects, :contract_on, :date, null:true
  end

  def down
    change_column :projects, :contract_on, :date, null:false
  end
end
