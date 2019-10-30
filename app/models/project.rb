# == Schema Information
# Schema version: 20191007083806
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
#  leader_id               :integer
#
# Indexes
#
#  index_projects_on_cd  (cd) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (group_id => project_groups.id) ON DELETE => nullify
#

# rubocop:disable Metrics/ClassLength
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

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/AbcSize
  def calc_expected_deposit_on(payment_type, bill_on)
    day = payment_type[/\d+/].to_i

    case payment_type
    when 'bill_on_15th_and_payment_on_end_of_next_month' # 15日締め翌月末払い
      if bill_on.day <= day
        Date.parse bill_on.since(1.month).end_of_month.strftime("%Y-%m-%d")
      else
        Date.parse bill_on.since(2.months).end_of_month.strftime("%Y-%m-%d")
      end
    when 'bill_on_20th_and_payment_on_end_of_next_month' # 20日締め翌月末払い
      if bill_on.day <= day
        Date.parse bill_on.since(1.month).end_of_month.strftime("%Y-%m-%d")
      else
        Date.parse bill_on.since(2.months).end_of_month.strftime("%Y-%m-%d")
      end
    when 'bill_on_end_of_month_and_payment_on_end_of_next_month' # 末日締め翌月末払い
      Date.parse bill_on.since(1.month).end_of_month.strftime("%Y-%m-%d")
    when 'bill_on_end_of_month_and_payment_on_15th_of_month_after_next' # 末日締め翌々月15日払い
      Date.parse bill_on.since(2.months).strftime("%Y-%m-#{day}")
    when 'bill_on_end_of_month_and_payment_on_20th_of_month_after_next' # 末日締め翌々月20日払い
      Date.parse bill_on.since(2.months).strftime("%Y-%m-#{day}")
    when 'bill_on_end_of_month_and_payment_on_end_of_month_after_next' # 末日締め翌々月末払い
      Date.parse bill_on.since(2.months).end_of_month.strftime("%Y-%m-%d")
    when 'bill_on_end_of_month_and_payment_on_35th' # 末日締め35日払い = 翌々月5日？
      Date.parse((bill_on + 35.days).strftime("%Y-%m-%d"))
    when 'bill_on_end_of_month_and_payment_on_45th' # 末日締め45日払い = 翌々月15日？
      Date.parse((bill_on + 45.days).strftime("%Y-%m-%d"))
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ClassLength
