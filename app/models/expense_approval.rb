# == Schema Information
# Schema version: 20190912021755
#
# Table name: expense_approvals
#
#  id              :integer          not null, primary key
#  total_amount    :integer
#  notes           :string
#  status          :integer          default("pending"), not null
#  created_user_id :integer
#  expenses_number :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string
#
# Foreign Keys
#
#  fk_rails_...  (created_user_id => users.id) ON DELETE => nullify
#

class ExpenseApproval < ApplicationRecord
  has_many :expense
  has_many :expense_approval_user
  has_many :users, through: :expense_approval_user

  belongs_to :created_user, class_name: "User"

  accepts_nested_attributes_for :expense_approval_user

  enum status: { pending: 10, permission: 20, disconfirm: 30, invalid: 40, unapplied: 50 }, _suffix: :expense

  scope :where_created_on, -> (created_at) { where(created_at: Date.strptime(created_at).beginning_of_day..Date.strptime(created_at).end_of_day) }
  scope :appr_id, -> { maximum(:id) || 0 }
  scope :my_appr, -> (current_user) { where(created_user_id: current_user).map(&:id).sort.reverse }
  scope :my_related_appr, lambda { |created_user_id|
    where(id: ExpenseApprovalUser.select(:expense_approval_id).where(user_id: created_user_id)).or(where(created_user_id: created_user_id))
  }

  has_paper_trail

  def invalidate_approval_users
    expense_approval_user.map(&:change_invalid)
  end

  def mine?(current_user)
    created_user_id == current_user.id
  end

  def self.search_expense_approval(current_user:, search_created_at: nil)
    result = if current_user.can?(:allread, ExpenseApproval)
               ExpenseApproval.all
             else
               ExpenseApproval.my_related_appr(current_user.id)
             end

    search_created_at.present? ? result.where_created_on(search_created_at) : result
  end
end
