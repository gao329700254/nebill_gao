# == Schema Information
# Schema version: 20160524030515
#
# Table name: partners
#
#  id           :integer          not null, primary key
#  company_name :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Partner < ActiveRecord::Base
  acts_as :employee

  has_many :members, through: :employee, class_name: 'PartnerMember'

  validates :name        , presence: true
  validates :company_name, presence: true

  def join!(project, unit_price, min_limit_time, max_limit_time)
    project.partner_members.create!(employee_id: employee.id, unit_price: unit_price, min_limit_time: min_limit_time, max_limit_time: max_limit_time)
  end
end
