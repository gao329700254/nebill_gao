class ChangeStatus < ActiveRecord::Migration[5.0]
  def change
    change_column :clients, :status, :integer, null: false, default: 20
  end
end
