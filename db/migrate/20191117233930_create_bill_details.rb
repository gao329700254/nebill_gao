class CreateBillDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_details do |t|
      t.string :content, null: false
      t.integer :amount
      t.references :bill, foreign_key: true, null: false

      t.timestamps
    end
  end
end
