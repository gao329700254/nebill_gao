# == Schema Information
# Schema version: 20171009095141
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
#  index_members_on_bill_id      (bill_id)
#  index_members_on_employee_id  (employee_id)
#  index_members_on_type         (type)
#
# Foreign Keys
#
#  fk_rails_1e30d6a7f9  (employee_id => employees.id)
#  fk_rails_a83d5bf563  (bill_id => bills.id)
#

class Member < ActiveRecord::Base
  belongs_to :employee
  belongs_to :bill
  has_paper_trail meta: { bill_id: :bill_id, project_id: :project_id }

  def project_id
    bill.project.id
  end
  validates :employee_id, uniqueness: { scope: :bill_id }
end
