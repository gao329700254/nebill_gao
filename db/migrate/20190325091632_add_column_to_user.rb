class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :crypted_password, :string
    add_column :users, :password_salt, :string
    add_column :users, :active, :boolean, null: false, default: false
    add_column :users, :perishable_token, :string
  end
end
