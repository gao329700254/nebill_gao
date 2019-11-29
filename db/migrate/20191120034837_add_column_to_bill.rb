class AddColumnToBill < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :create_user_id, :integer, null: false
  end
end
