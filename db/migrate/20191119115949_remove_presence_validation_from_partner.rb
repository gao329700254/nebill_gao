class RemovePresenceValidationFromPartner < ActiveRecord::Migration[5.0]
  def up
    change_column_null :partners, :cd, true
    change_column_null :partners, :company_name, true
    remove_column :partners, :company_name
    remove_column :partners, :address
    remove_column :partners, :zip_code
    remove_column :partners, :phone_number

    add_reference :partners, :client
  end

  def down
    change_column_null :partners, :cd, false
    change_column_null :partners, :company_name, false
    add_column :partners, :company_name, :string
    add_column :partners, :address, :string
    add_column :partners, :zip_code, :string
    add_column :partners, :phone_number, :string

    remove_reference :partners, :client
  end
end
