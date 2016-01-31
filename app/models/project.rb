# == Schema Information
# Schema version: 20160126045155
#
# Table name: projects
#
#  id                      :integer          not null, primary key
#  key                     :string           not null
#  name                    :string           not null
#  contract_type           :string           not null
#  start_on                :date             not null
#  end_on                  :date
#  amount                  :integer
#  billing_company_name    :string
#  billing_department_name :string
#  billing_personnel_names :string
#  billing_address         :string
#  billing_zip_code        :string
#  billing_memo            :text
#  orderer_company_name    :string
#  orderer_department_name :string
#  orderer_personnel_names :string
#  orderer_address         :string
#  orderer_zip_code        :string
#  orderer_memo            :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_projects_on_key       (key) UNIQUE
#  index_projects_on_start_on  (start_on)
#

class Project < ActiveRecord::Base
  extend Enumerize

  validates :key          , presence: true, uniqueness: { case_sensitive: false }
  validates :contract_type, presence: true
  validates :start_on     , presence: true
  validates :amount       , numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enumerize :contract_type, in: [:lump_sum, :uasimandate]

  serialize :billing_personnel_names, Array
  serialize :orderer_personnel_names, Array

  composed_of :billing,
              class_name: 'DestinationInformation',
              mapping: %w(company_name department_name personnel_names address zip_code memo).map { |attr_name| ["billing_#{attr_name}", attr_name] }
  composed_of :orderer,
              class_name: 'DestinationInformation',
              mapping: %w(company_name department_name personnel_names address zip_code memo).map { |attr_name| ["orderer_#{attr_name}", attr_name] }

  before_save { key.upcase! }
end
