# == Schema Information
# Schema version: 20160524044507
#
# Table name: members
#
#  id          :integer          not null, primary key
#  employee_id :integer          not null
#  project_id  :integer          not null
#
# Indexes
#
#  index_members_on_employee_id_and_project_id  (employee_id,project_id) UNIQUE
#  index_members_on_project_id                  (project_id)
#

class Member < ActiveRecord::Base
  belongs_to :employee
  belongs_to :project
  has_one :user   , through: :employee, source: :actable, source_type: User
  has_one :partner, through: :employee, source: :actable, source_type: Partner

  validates :employee_id, uniqueness: { scope: :project_id }
end
