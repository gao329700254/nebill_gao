class AddStatusToClients < ActiveRecord::Migration
  def change
    add_column :clients, :status, :integer
  end
end
