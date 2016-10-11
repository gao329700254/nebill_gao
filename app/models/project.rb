# == Schema Information
# Schema version: 20161003063433
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
#  billing_address         :string
#  billing_zip_code        :string
#  billing_memo            :text
#  orderer_company_name    :string
#  orderer_department_name :string
#  orderer_address         :string
#  orderer_zip_code        :string
#  orderer_memo            :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  is_using_ses            :boolean
#  group_id                :integer
#  payment_type            :string
#  billing_personnel_names :string           is an Array
#  orderer_personnel_names :string           is an Array
#
# Indexes
#
#  index_projects_on_key  (key) UNIQUE
#
# Foreign Keys
#
#  fk_rails_a3d5742497  (group_id => project_groups.id)
#

class Project < ActiveRecord::Base
  extend Enumerize
  include ProjectValidates

  belongs_to :group, class_name: 'ProjectGroup'
  has_many :members
  has_many :user_members
  has_many :partner_members
  has_many :employees, through: :members
  has_many :users, through: :user_members
  has_many :partners, through: :partner_members
  has_many :bills
  has_many :files, class_name: 'ProjectFile'
  has_many :file_groups, class_name: 'ProjectFileGroup'

  enumerize :contract_type, in: [:lump_sum, :uasimandate, :consignment, :maintenance, :other]
  enumerize :payment_type, in: %w(
    bill_on_15th_and_payment_on_end_of_next_month
    bill_on_20th_and_payment_on_end_of_next_month
    bill_on_end_of_month_and_payment_on_end_of_next_month
    bill_on_end_of_month_and_payment_on_15th_of_month_after_next
    bill_on_end_of_month_and_payment_on_20th_of_month_after_next
    bill_on_end_of_month_and_payment_on_end_of_month_after_next
    bill_on_end_of_month_and_payment_on_35th
    bill_on_end_of_month_and_payment_on_45th
  )

  composed_of :billing,
              class_name: 'DestinationInformation',
              mapping: %w(company_name department_name personnel_names address zip_code memo).map { |attr_name| ["billing_#{attr_name}", attr_name] }
  composed_of :orderer,
              class_name: 'DestinationInformation',
              mapping: %w(company_name department_name personnel_names address zip_code memo).map { |attr_name| ["orderer_#{attr_name}", attr_name] }

  before_save { key.upcase! }

  def self.sequence(prefix)
    @max_sequence = where('key LIKE ?', "%#{prefix}%").pluck(:key).map { |key| key.gsub(prefix, "").to_i }.max
    @sequence = @max_sequence ? @max_sequence + 1 : 1
  end
end
