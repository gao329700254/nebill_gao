# == Schema Information
# Schema version: 20191007083806
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

class Partner < ApplicationRecord
  acts_as :employee

  belongs_to :client, optional: true

  has_many :members, through: :employee, class_name: 'PartnerMember'

  validates :name, presence: true
end
