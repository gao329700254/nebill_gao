class ChangeDatetypeInvTypeToPayeeAccounts < ActiveRecord::Migration
  def up
    change_column :payee_accounts, :inv_type, 'integer USING CAST(inv_type AS integer)'
  end
  def down
    change_column :payee_accounts, :inv_type, :string
  end
end
