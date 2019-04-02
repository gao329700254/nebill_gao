# == Schema Information
# Schema version: 20190409072211
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
end
