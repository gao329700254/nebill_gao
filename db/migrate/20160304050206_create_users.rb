class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # omniauth
      t.string :provider         , null: true
      t.string :uid              , null: true
      t.string :name             , null: true
      t.string :email            , null: false

      # authlogic
      t.string   :persistence_token , null: false
      t.integer  :login_count       , null: false, default: 0
      t.integer  :failed_login_count, null: false, default: 0
      t.datetime :current_login_at
      t.datetime :last_login_at

      # other
      t.boolean :is_admin, null: false, default: false

      t.timestamps null: false
    end
    add_index :users, [:provider, :uid], unique: true
    add_index :users, [:email]         , unique: true
  end
end
