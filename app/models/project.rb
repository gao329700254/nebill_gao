# == Schema Information
# Schema version: 20190911034541
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
#  contractual_coverage    :string
#  is_using_ses            :boolean
#  group_id                :integer
#  payment_type            :string
#
# Indexes
#
#  index_projects_on_cd  (cd) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (group_id => project_groups.id) ON DELETE => nullify
#

class Project < ApplicationRecord
  extend Enumerize
  include ProjectValidates

  belongs_to :group, class_name: 'ProjectGroup'
  has_many :bills, dependent: :destroy
  has_many :members, class_name: 'Member', dependent: :destroy
  has_many :files, class_name: 'ProjectFile', dependent: :destroy
  has_many :file_groups, class_name: 'ProjectFileGroup', dependent: :destroy
  has_many :approvals, as: :approved
  has_many :user_members
  has_many :partner_members
  has_many :users, through: :user_members
  has_many :partners, through: :partner_members
  has_paper_trail meta: { project_id: :id }

  accepts_nested_attributes_for :members, allow_destroy: true

  enumerize :contract_type, in: [:lump_sum, :consignment, :maintenance, :ses, :other]
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
  enumerize :status, in: [:receive_order, :unreceive_order, :turn_over, :publish_bill, :finished], default: :unreceive_order

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

  before_save { cd.upcase! }

  scope :between, lambda { |start_on, end_on|
    where(Project.arel_table[:start_on].gteq(start_on)).where(Project.arel_table[:end_on].lteq(end_on))
  }
  scope :gteq_start_on, -> (start_on) { where(Project.arel_table[:start_on].gteq(start_on)) }
  scope :lteq_end_on, -> (end_on) { where(Project.arel_table[:end_on].lteq(end_on)) }

  def self.next_sequence(prefix)
    @max_sequence = where('cd LIKE ?', "%#{prefix}%").pluck(:cd).map { |cd| cd.gsub(prefix, "").to_i }.max
    @max_sequence.present? ? @max_sequence + 1 : 1
  end

  def amount=(value)
    super(value.delete(',')) if value
  end

  def estimated_amount=(value)
    super(value.delete(',')) if value
  end

  def csv_columns
    [
      status.finished? ? I18n.t('page.project_list.project_status.finished') : I18n.t('page.project_list.project_status.progress'),
      cd,
      name,
      orderer_company_name,
      amount&.to_s(:delimited),
      contracted? ? '済' : '',
      start_on.to_s,
      end_on.to_s,
      memo,
    ]
  end
end
