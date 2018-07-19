class RemoveIsAdminFromUsers < ActiveRecord::Migration
  class MigrationUser < ActiveRecord::Base
    self.table_name = :users
  end

  def up
    MigrationUser.find_each do |user|
      user.update!(role: 50) if user.is_admin
    end

    remove_column :users, :is_admin, :boolean
  end

  def down
    add_column :users, :is_admin, :boolean
    MigrationUser.reset_column_information

    MigrationUser.find_each do |user|
      case user.role
      when *[50, 40]
        user.update!(is_admin: true, role: 10)
      when 30
        user.update!(is_admin: false, role: 30)
      when 10
        user.update!(is_admin: false, role: 10)
      end
    end
  end
end
