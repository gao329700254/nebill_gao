class ChangeColumnNamesKeyToCd < ActiveRecord::Migration
  def change
    %i(
      bills
      clients
      projects
    ).each do |table|
      rename_column table, :key, :cd
    end
  end
end
