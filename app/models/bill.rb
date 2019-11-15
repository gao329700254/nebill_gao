# == Schema Information
# Schema version: 20191120034837
#
# Table name: bills
#
#  id                  :integer          not null, primary key
#  project_id          :integer          not null
#  cd                  :string           not null
#  delivery_on         :date             not null
#  acceptance_on       :date             not null
#  bill_on             :date             not null
#  deposit_on          :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  memo                :text
#  amount              :integer          default(0), not null
#  payment_type        :string           not null
#  expected_deposit_on :date             not null
#  status              :integer          default("unapplied"), not null
#  create_user_id      :integer          not null
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
  belongs_to :create_user, class_name: 'User'
  has_one    :applicant, class_name: 'BillApplicant', dependent: :destroy
  has_many   :approvers, class_name: 'BillApprovalUser', dependent: :destroy
  has_many   :users, through: :approvers

  enum status: { unapplied: 10, pending: 20, approved: 30, sent_back: 40, cancelled: 50, issued: 60, confirmed: 70 }, _suffix: :bill

  has_paper_trail meta: { project_id: :project_id, bill_id: :id }

  validates :cd                 , presence: true, uniqueness: { case_sensitive: false }
  validates :amount             , presence: true
  validates :delivery_on        , presence: true
  validates :acceptance_on      , presence: true
  validates :payment_type       , presence: true
  validates :bill_on            , presence: true
  validates :expected_deposit_on, presence: true
  validate  :bill_on_cannot_predate_delivery_on
  validate  :bill_on_cannot_predate_acceptance_on
  validates :deposit_on, presence: true, if: :deposit_on_valid?

  def deposit_on_valid?
    status == 'confirmed'
  end

  before_save { cd.upcase! }

  scope :between, lambda { |start_on, end_on|
    where(Bill.arel_table[:bill_on].gteq(start_on)).where(Bill.arel_table[:bill_on].lteq(end_on))
  }
  scope :gteq_start_on, -> (start_on) { where(Bill.arel_table[:bill_on].gteq(start_on)) }
  scope :lteq_end_on, -> (end_on) { where(Bill.arel_table[:bill_on].lteq(end_on)) }

  def bill_on_cannot_predate_delivery_on
    return if bill_on.nil? || delivery_on.nil? || bill_on >= delivery_on
    errors.add(:bill_on, I18n.t('errors.messages.wrong_bill_on_predate_delivery_on'))
  end

  def bill_on_cannot_predate_acceptance_on
    return if bill_on.nil? || acceptance_on.nil? || bill_on >= acceptance_on
    errors.add(:bill_on, I18n.t('errors.messages.wrong_bill_on_predate_acceptance_on'))
  end

  def primary_approver
    approvers.primary_role.first
  end

  def secondary_approver
    approvers.secondary_role.first
  end

  def make_bill_application!(applicant_id, comment, user_id, reapply)
    ActiveRecord::Base.transaction do
      build_applicant(user_id: applicant_id, comment: comment).save!
      pending_bill!

      # 承認者の洗い替え
      approvers.destroy_all if reapply.present?
      create_primary_approver!(user_id)
    end
  end

  def create_primary_approver!(user_id)
    approvers.create!(role: 'primary', status: 'pending', user_id: user_id)
    Chatwork::Bill.new(bill: self, to_user: primary_approver.user, from_user: applicant).notify_assigned
  end

  def create_secondary_approver!
    chief = User.find_by(is_chief: true)
    approvers.create!(role: 'secondary', status: 'pending', user_id: chief.id)
    Chatwork::Bill.new(bill: self, to_user: secondary_approver.user, from_user: applicant).notify_assigned
  end

  def cancel_bill_application!
    ActiveRecord::Base.transaction do
      cancelled_bill!
      applicant.destroy!
      approvers.destroy_all
    end
  end

  def approve_bill_application!(user_id, comment)
    current_approver = approvers.find_by(user_id: user_id)

    ActiveRecord::Base.transaction do
      current_approver.update!(status: 'approved', comment: comment)

      if current_approver.primary_role?
        create_secondary_approver!
      else
        approved_bill!
        Chatwork::Bill.new(bill: self, to_user: applicant.user).notify_approved
      end
    end
  end

  def send_back_bill_application!(user, comment)
    current_approver = approvers.find_by(user_id: user.id)

    ActiveRecord::Base.transaction do
      sent_back_bill!
      current_approver.update!(status: 'sent_back', comment: comment)
      approvers.each(&:sent_back_bill!)

      Chatwork::Bill.new(bill: self, to_user: applicant.user, from_user: current_approver).notify_sent_back
    end
  end

#
# == bill_issuedの検索およびindex用の処理
# == endは予約後のため引数はbill_endとした
# 

  def self.issued_search_result(start, bill_end)
    if start.present? && bill_end.present?
      between(start, bill_end)
    elsif start.present?
      gteq_start_on(start)
    elsif bill_end.present?
      lteq_end_on(bill_end)
    else
      all
    end
  end

end
