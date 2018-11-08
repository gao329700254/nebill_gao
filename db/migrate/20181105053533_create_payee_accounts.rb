class CreatePayeeAccounts < ActiveRecord::Migration
  def change
    create_table :payee_accounts do |t|
      t.integer :employee_id, null: false
      t.integer :bank_code
      t.integer :filial_code
      t.string  :inv_type, limit: 5
      t.string  :inv_number, limit: 15
      t.string  :employee, limit: 200

    end
  end
end
