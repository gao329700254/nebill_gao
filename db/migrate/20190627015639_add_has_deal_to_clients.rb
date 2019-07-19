class AddHasDealToClients < ActiveRecord::Migration
  def change
    add_column :clients, :is_valid, :boolean, default: true
  end
end
