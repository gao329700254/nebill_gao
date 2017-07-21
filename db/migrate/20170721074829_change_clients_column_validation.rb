class ChangeClientsColumnValidation < ActiveRecord::Migration
  def up
    change_column :clients, :cd, :string, null:true
    change_column :clients, :company_name, :string, null:false
  end

  def down
    change_column :clients, :cd, :string, null:false
    change_column :clients, :company_name, :string, null:true
  end
end
