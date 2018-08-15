class RenameImmediateBossColumnToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :immediate_boss, :default_allower
  end
end
