class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string   :key            , null: false
      t.string   :company_name   , null: true
      t.string   :department_name, null: true
      t.string   :address        , null: true
      t.string   :zip_code       , null: true
      t.string   :phone_number   , null: true
      t.text     :memo           , null: true

      t.timestamps null: false
    end
  end
end
