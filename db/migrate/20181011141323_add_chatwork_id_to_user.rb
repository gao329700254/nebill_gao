class AddChatworkIdToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :chatwork_id
      t.string  :chatwork_name
    end
  end
end
