# == Schema Information
# Schema version: 20171009095141
#
# Table name: partners
#
#  id           :integer          not null, primary key
#  company_name :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  cd           :string           not null
#  address      :string
#  zip_code     :string
#  phone_number :string
#
# Indexes
#
#  index_partners_on_cd  (cd)
#

class Partner < ActiveRecord::Base
  acts_as :employee

  has_many :members, through: :employee, class_name: 'PartnerMember'

  validates :cd          , presence: true, uniqueness: { case_sensitive: false }
  validates :name        , presence: true
  validates :company_name, presence: true

  before_save { cd.upcase! }

  def join!(bill, unit_price, working_rate, min_limit_time, max_limit_time)
    bill.partner_members.create!(
      employee_id:    employee.id,
      unit_price:     unit_price,
      working_rate:   working_rate,
      min_limit_time: min_limit_time,
      max_limit_time: max_limit_time,
    )
  end
end
