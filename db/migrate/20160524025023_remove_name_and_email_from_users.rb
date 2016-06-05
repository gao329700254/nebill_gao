class RemoveNameAndEmailFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :name
    remove_column :users, :email
  end

  def down
    add_column :users, :name , :string
    add_column :users, :email, :string

    User.all.each_with_index do |user, i|
      user.name = "name #{i}"
      user.email = "example#{i}@example.com"
      user.save!
    end

    change_column :users, :email, :string, null: false

    add_index :users, [:email]         , unique: true
  end
end
