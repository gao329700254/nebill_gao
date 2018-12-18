class AddLegalCheckToClientFiles < ActiveRecord::Migration
  def change
    add_column :client_files, :legal_check, :boolean, default: false
  end
end
