# == Schema Information
# Schema version: 20190912021755
#
# Table name: expense_approval_users
#
#  id                  :integer          not null, primary key
#  expense_approval_id :integer
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  status              :string
#  comment             :string
#
# Foreign Keys
#
#  fk_rails_...  (expense_approval_id => expense_approvals.id) ON DELETE => nullify
#  fk_rails_...  (user_id => users.id) ON DELETE => nullify
#

class ExpenseApprovalUser < ApplicationRecord
  extend Enumerize
  belongs_to :user
  belongs_to :expense_approval

  enumerize :status, in: { pending: 10, permission: 20, disconfirm: 30, reassignment: 40, invalid: 50 }, default: :pending

  scope :with_permission, -> { where(status: 20) }
  scope :with_disconfirm, -> { where(status: 30) }

  def change_invalid
    self.status = :invalid
  end
end
