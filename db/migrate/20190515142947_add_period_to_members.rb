class AddPeriodToMembers < ActiveRecord::Migration
  def change
    add_column :members, :working_period_start, :date
    add_column :members, :working_period_end, :date
    add_column :members, :man_month, :float
  end
end
