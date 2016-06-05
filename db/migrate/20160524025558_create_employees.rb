class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :actable_id       , null: false
      t.string  :actable_type     , null: false
      t.string  :name             , null: true
      t.string  :email            , null: false

      t.timestamps null: false
    end

    add_index :employees, [:email]         , unique: true
  end
end
