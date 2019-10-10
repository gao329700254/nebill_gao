# == Schema Information
# Schema version: 20190925020855
#
# Table name: bills
#
#  id                  :integer          not null, primary key
#  project_id          :integer          not null
#  cd                  :string           not null
#  delivery_on         :date             not null
#  acceptance_on       :date             not null
#  bill_on             :date
#  deposit_on          :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  memo                :text
#  amount              :integer          default(0), not null
#  payment_type        :string
#  expected_deposit_on :date
#  status              :integer          default("unapplied"), not null
#
# Indexes
#
#  index_bills_on_cd  (cd) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id) ON DELETE => cascade
#

class Bill < ApplicationRecord
  belongs_to :project
  has_many :user_members
  has_many :users, through: :user_members

  enum status: { unapplied: 10, pending: 20, approved: 30, sent_back: 40, cancelled: 50, issued: 60 }, _suffix: :bill

  has_paper_trail meta: { project_id: :project_id, bill_id: :id }

  validates :cd                 , presence: true, uniqueness: { case_sensitive: false }
  validates :amount             , presence: true
  validates :delivery_on        , presence: true
  validates :acceptance_on      , presence: true
  validates :expected_deposit_on, presence: true
  validate  :bill_on_cannot_predate_delivery_on
  validate  :bill_on_cannot_predate_acceptance_on

  before_save { cd.upcase! }

  scope :between, lambda { |start_on, end_on|
    where(Bill.arel_table[:bill_on].gteq(start_on)).where(Bill.arel_table[:bill_on].lteq(end_on))
  }
  scope :gteq_start_on, -> (start_on) { where(Bill.arel_table[:bill_on].gteq(start_on)) }
  scope :lteq_end_on, -> (end_on) { where(Bill.arel_table[:bill_on].lteq(end_on)) }

  def bill_on_cannot_predate_delivery_on
    return if bill_on.nil?
    errors.add(:bill_on, I18n.t('errors.messages.wrong_bill_on_predate_delivery_on')) if bill_on < delivery_on
  end

  def bill_on_cannot_predate_acceptance_on
    return if bill_on.nil?
    errors.add(:bill_on, I18n.t('errors.messages.wrong_bill_on_predate_acceptance_on')) if bill_on < acceptance_on
  end
end
