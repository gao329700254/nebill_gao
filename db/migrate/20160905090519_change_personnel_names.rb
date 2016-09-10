class ChangePersonnelNames < ActiveRecord::Migration
  def up
    remove_column :projects, :billing_personnel_names
    add_column    :projects, :billing_personnel_names, :string, array: true, null: true
    remove_column :projects, :orderer_personnel_names
    add_column    :projects, :orderer_personnel_names, :string, array: true, null: true
  end

  def down
    remove_column :projects, :billing_personnel_names
    add_column    :projects, :billing_personnel_names, :string, array: false, null: true
    remove_column :projects, :orderer_personnel_names
    add_column    :projects, :orderer_personnel_names, :string, array: false, null: true
  end
end
