class AddPhoneNumberToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :orderer_phone_number, :string, null: true
    add_column :projects, :billing_phone_number, :string, null: true
  end
end
