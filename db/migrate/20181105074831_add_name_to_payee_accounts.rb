class AddNameToPayeeAccounts < ActiveRecord::Migration
  def change
    add_column :payee_accounts, :bank_name, :string
    add_column :payee_accounts, :filial_name, :string
  end
end
