# == Schema Information
# Schema version: 20170810082756
#
# Table name: members
#
#  id             :integer          not null, primary key
#  employee_id    :integer          not null
#  project_id     :integer          not null
#  type           :string           not null
#  unit_price     :integer
#  min_limit_time :integer
#  max_limit_time :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  working_rate   :float
#
# Indexes
#
#  index_members_on_employee_id_and_project_id  (employee_id,project_id) UNIQUE
#  index_members_on_project_id                  (project_id)
#  index_members_on_type                        (type)
#
# Foreign Keys
#
#  fk_rails_1e30d6a7f9  (employee_id => employees.id)
#  fk_rails_7054080f33  (project_id => projects.id)
#

class PartnerMember < Member
  has_one :partner, through: :employee, source: :actable, source_type: Partner

  accepts_nested_attributes_for :partner

  validates :min_limit_time, numericality: { only_integer: true }, allow_nil: true
  validates :max_limit_time, numericality: { only_integer: true }, allow_nil: true
  validates :working_rate  , numericality: true, allow_nil: true
end
