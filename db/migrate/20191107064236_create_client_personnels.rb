class CreateClientPersonnels < ActiveRecord::Migration[5.0]
  def change
    create_table :client_personnels do |t|
      t.references :client, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.string :mail
      t.string :cc
      t.string :phone_number

      t.timestamps
    end
  end
end
