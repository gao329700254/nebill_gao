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
  has_one    :bill_applicant,      dependent: :destroy
  has_many   :bill_approval_users, dependent: :destroy
  has_many   :users, through: :bill_approval_users

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

  def secondary_approver
    bill_approval_users.secondary_role.first
  end

  def update_bill_and_applicant!(comment)
    pending_bill!
    bill_applicant.update!(comment: comment)
  end

  def create_bill_approval_users!(user_id)
    # 申請時に選択されたユーザを一段目承認者として作成する
    bill_approval_users.create!(role: 'primary', status: 'pending', user_id: user_id)

    # 「社長フラグ(= is_chief)」を有するユーザを二段目承認者として作成する
    chief = User.find_by(is_chief: true)
    bill_approval_users.create!(role: 'secondary', status: 'pending', user_id: chief.id)
  end

  def recreate_bill_approval_users!(user_id)
    # 承認者の洗い替え
    bill_approval_users.destroy_all
    create_bill_approval_users!(user_id)
  end

  def cancel_apply!
    cancelled_bill!
    bill_approval_users.destroy_all
  end

  def approve_bill_application!(user_id, comment)
    current_approver = bill_approval_users.find_by(user_id: user_id)

    # 二段目承認者が承認＝承認者全員が承認したときに、請求のステータスを「承認済み」に更新する
    approved_bill! if current_approver.secondary_role?
    current_approver.update!(status: 'approved', comment: comment)
  end

  def send_back_bill_application!(user_id, comment)
    sent_back_bill!
    bill_approval_users.find_by(user_id: user_id).update!(status: 'sent_back', comment: comment)
    bill_approval_users.each(&:sent_back_bill!)
  end
end
