class AddColumnToMember < ActiveRecord::Migration
  def up
    add_column :members, :type, :string, null: true
    Member.all.each do |member|
      case member.employee.actable_type
      when 'User'
        member.type = 'UserMember'
        member.save!
      when 'Partner'
        member.type = 'PartnerMember'
        member.unit_price = 0
        member.save!
      end
    end
    change_column :members, :type, :string, null: false

    add_index  :members, :type
    add_column :members, :unit_price, :integer
    add_column :members, :min_limit_time, :integer
    add_column :members, :max_limit_time, :integer
  end

  def down
    remove_column :members, :type
    remove_index  :members, :type
    remove_column :members, :unit_price
    remove_column :members, :min_limit_time
    remove_column :members, :max_limit_time
  end
end
