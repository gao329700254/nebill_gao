class ChangeStatus < ActiveRecord::Migration[5.0]
  def up
    change_column :clients, :status, :integer, null: false, default: 20
  end

  def down
    change_column :clients, :status, :integer, null: true, default: nil
  end
end
