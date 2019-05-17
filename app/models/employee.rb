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

class Employee < ActiveRecord::Base
  actable

  has_many :members

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }

  def join!(project, params)
    project.user_members.create!(
      employee_id: id,
      working_period_start: params[:working_period_start],
      working_period_end: params[:working_period_end],
      man_month: params[:man_month],
    )
  end
end
