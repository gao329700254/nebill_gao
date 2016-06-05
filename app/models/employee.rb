# == Schema Information
# Schema version: 20160524030515
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
  has_many :projects, through: :members

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
