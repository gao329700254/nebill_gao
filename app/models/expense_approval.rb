# == Schema Information
# Schema version: 20190108060032
#
# Table name: expense_approvals
#
#  id              :integer          not null, primary key
#  total_amount    :integer
#  notes           :string
#  status          :integer
#  created_user_id :integer
#  expenses_number :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string
#
# Foreign Keys
#
#  fk_rails_17af6d1f20  (created_user_id => users.id)
#

class ExpenseApproval < ActiveRecord::Base
  extend Enumerize
  has_many :expense
  has_many :expense_approval_user
  has_many :users, through: :expense_approval_user

  belongs_to :created_user, class_name: "User"

  enumerize :status, in: { pending: 10, permission: 20, disconfirm: 30, invalid: 40, unapplied: 50 }, default: :pending

  scope :where_created_at, -> (created_at) { where(created_at: Date.strptime(created_at).beginning_of_day..Date.strptime(created_at).end_of_day) }
  scope :appr_id, -> { maximum(:id) || 0 }
  scope :my_appr, -> (current_user) { where(created_user_id: current_user).map(&:id).sort.reverse }
end
