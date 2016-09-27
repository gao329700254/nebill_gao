class AddTimestampsToMembers < ActiveRecord::Migration
  def up
    add_timestamps :members, null: true
    Member.all.each do |member|
      member.created_at = Time.now
      member.updated_at = Time.now
      member.save!
    end
    change_column :members, :created_at, :timestamp, null: false
    change_column :members, :updated_at, :timestamp, null: false
  end

  def down
    remove_column :members, :created_at, :timestamp
    remove_column :members, :updated_at, :timestamp
  end
end
