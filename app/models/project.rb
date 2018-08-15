# == Schema Information
# Schema version: 20180815005533
#
# Table name: projects
#
#  id                      :integer          not null, primary key
#  cd                      :string           not null
#  name                    :string           not null
#  contracted              :boolean          not null
#  contract_on             :date
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
#  estimated_amount        :integer
#  is_regular_contract     :boolean
#  status                  :string
#  orderer_phone_number    :string
#  billing_phone_number    :string
#  memo                    :text
#  unprocessed             :boolean          default(FALSE)
#
# Indexes
#
#  index_projects_on_cd  (cd) UNIQUE
#
# Foreign Keys
#
#  fk_rails_a3d5742497  (group_id => project_groups.id)
#

class Project < ActiveRecord::Base
  extend Enumerize
  include ProjectValidates

  belongs_to :group, class_name: 'ProjectGroup'
  has_many :bills, dependent: :destroy
  has_many :files, class_name: 'ProjectFile', dependent: :destroy
  has_many :file_groups, class_name: 'ProjectFileGroup', dependent: :destroy
  has_many :approvals, as: :approved
  has_paper_trail meta: { project_id: :id }

  enumerize :contract_type, in: [:lump_sum, :consignment, :maintenance, :other]
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
  enumerize :status, in: [:receive_order, :turn_over, :publish_bill, :finished]

  composed_of :billing,
              class_name: 'DestinationInformation',
              mapping: %w(
                company_name
                department_name
                personnel_names
                address
                zip_code
                phone_number
                memo
              ).map { |attr_name| ["billing_#{attr_name}", attr_name] }
  composed_of :orderer,
              class_name: 'DestinationInformation',
              mapping: %w(
                company_name
                department_name
                personnel_names
                address zip_code
                phone_number
                memo
              ).map { |attr_name| ["orderer_#{attr_name}", attr_name] }

  validates :cd, format: { with: /\A\d{2}[a-z|A-Z]\d{3}[AB]?\z/ }

  before_save { cd.upcase! }

  scope :between, lambda { |start_on, end_on|
    where(Project.arel_table[:start_on].gteq(start_on)).where(Project.arel_table[:end_on].lteq(end_on))
  }
  scope :gteq_start_on, -> (start_on) { where(Project.arel_table[:start_on].gteq(start_on)) }
  scope :lteq_end_on, -> (end_on) { where(Project.arel_table[:end_on].lteq(end_on)) }

  def self.sequence(prefix)
    @max_sequence = where('cd LIKE ?', "%#{prefix}%").pluck(:cd).map { |cd| cd.gsub(prefix, "").to_i }.max
    @sequence = @max_sequence ? @max_sequence + 1 : 1
  end
end
