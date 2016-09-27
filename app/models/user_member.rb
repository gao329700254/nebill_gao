# == Schema Information
# Schema version: 20160923105401
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
#
# Indexes
#
#  index_members_on_employee_id_and_project_id  (employee_id,project_id) UNIQUE
#  index_members_on_project_id                  (project_id)
#  index_members_on_type                        (type)
#

class UserMember < Member
  has_one :user, through: :employee, source: :actable, source_type: User

  validates :unit_price, :min_limit_time, :max_limit_time, absence: true
end
