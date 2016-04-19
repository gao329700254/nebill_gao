class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer  :project_id             , null: false
      t.string   :key                    , null: false
      t.date     :delivery_on            , null: false
      t.date     :acceptance_on          , null: false
      t.string   :payment_type           , null: false
      t.date     :payment_on             , null: false
      t.date     :bill_on                , null: true
      t.date     :deposit_on             , null: true

      t.timestamps null: false
    end
    add_index :bills, :key, unique: true
  end
end
