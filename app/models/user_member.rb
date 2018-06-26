# == Schema Information
# Schema version: 20180620035125
#
# Table name: members
#
#  id             :integer          not null, primary key
#  employee_id    :integer          not null
#  type           :string           not null
#  unit_price     :integer
#  min_limit_time :integer
#  max_limit_time :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  working_rate   :float
#  bill_id        :integer          not null
#
# Indexes
#
#  index_members_on_bill_id                  (bill_id)
#  index_members_on_employee_id_and_bill_id  (employee_id,bill_id) UNIQUE
#  index_members_on_type                     (type)
#
# Foreign Keys
#
#  fk_rails_1e30d6a7f9  (employee_id => employees.id)
#  fk_rails_a83d5bf563  (bill_id => bills.id)
#

class UserMember < Member
  has_one :user, through: :employee, source: :actable, source_type: User

  validates :unit_price, :working_rate, :min_limit_time, :max_limit_time, absence: true
end
