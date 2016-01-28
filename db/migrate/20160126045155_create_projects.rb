class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string   :key                    , null: false
      t.string   :name                   , null: false
      t.string   :contract_type          , null: false
      t.date     :start_on               , null: false, index: true
      t.date     :end_on                 , null: true
      t.integer  :amount                 , null: true
      t.string   :billing_company_name   , null: true
      t.string   :billing_department_name, null: true
      t.string   :billing_personnel_names, null: true
      t.string   :billing_address        , null: true
      t.string   :billing_zip_code       , null: true
      t.text     :billing_memo           , null: true
      t.string   :orderer_company_name   , null: true
      t.string   :orderer_department_name, null: true
      t.string   :orderer_personnel_names, null: true
      t.string   :orderer_address        , null: true
      t.string   :orderer_zip_code       , null: true
      t.text     :orderer_memo           , null: true

      t.timestamps null: false
    end
    add_index :projects, :key, unique: true
  end
end
