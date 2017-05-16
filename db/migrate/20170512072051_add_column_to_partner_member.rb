class AddColumnToPartnerMember < ActiveRecord::Migration
  def change
    add_column :members, :working_rate, :float
  end
end
