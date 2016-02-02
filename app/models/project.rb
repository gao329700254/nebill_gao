# == Schema Information
# Schema version: 20160126045155
#
# Table name: projects
#
#  id                      :integer          not null, primary key
#  key                     :string           not null
#  name                    :string           not null
#  contracted              :boolean          not null
#  contract_on             :date             not null
#  contract_type           :string
#  start_on                :date
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
#  index_projects_on_key  (key) UNIQUE
#

class Project < ActiveRecord::Base
  extend Enumerize
  include ProjectValidates

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
