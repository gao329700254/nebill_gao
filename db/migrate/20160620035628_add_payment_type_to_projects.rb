class AddPaymentTypeToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :payment_type, :string, null: true

    Project.where(contracted: true).each do |project|
      project.payment_type = 'end_of_the_delivery_date_next_month'
      project.save!
    end
  end

  def down
    remove_column :projects, :payment_type
  end
end
