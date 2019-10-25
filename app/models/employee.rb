# == Schema Information
# Schema version: 20170810082756
#
# Table name: employees
#
#  id           :integer          not null, primary key
#  actable_id   :integer          not null
#  actable_type :string           not null
#  name         :string
#  email        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_employees_on_email  (email) UNIQUE
#

class Employee < ApplicationRecord
  actable

  has_many :members

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }

  def create_user_member_in_nebill_and_sf!(project, partner_params)
    user_member = project.user_members.create!(
      employee_id:          id,
      working_period_start: partner_params[:working_period_start],
      working_period_end:   partner_params[:working_period_end],
      man_month:            partner_params[:man_month],
    )
    user_member.create_in_sf
    user_member
  end
end
