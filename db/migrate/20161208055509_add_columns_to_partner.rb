class AddColumnsToPartner < ActiveRecord::Migration
  def up
    add_column :partners, :cd          , :string, null: true
    add_column :partners, :address     , :string, null: true
    add_column :partners, :zip_code    , :string, null: true
    add_column :partners, :phone_number, :string, null: true

    Partner.all.each do |p|
      p.cd = p.id
      p.save!
    end

    change_column :partners, :cd, :string, null: false
    add_index :partners, :cd
  end

  def down
    remove_column :partners, :cd
    remove_index  :partners, :cd
    remove_column :partners, :address
    remove_column :partners, :zip_code
    remove_column :partners, :phone_number
  end
end
