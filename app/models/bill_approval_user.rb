# == Schema Information
# Schema version: 20191007052937
#
# Table name: bill_approval_users
#
#  id         :integer          not null, primary key
#  role       :integer          not null
#  status     :integer          default("unapplied"), not null
#  comment    :string
#  user_id    :integer          not null
#  bill_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bill_approval_users_on_bill_id  (bill_id)
#  index_bill_approval_users_on_user_id  (user_id)
#

class BillApprovalUser < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :bill, required: true

  validates :role,    presence: true
  validates :status,  presence: true
  validates :comment, length: { maximum: 200 }

  enum role:   { primary: 10, secondary: 20 }, _suffix: true
  enum status: { unapplied: 10, pending: 20, approved: 30, sent_back: 40, cancelled: 50 }, _suffix: :bill
end
