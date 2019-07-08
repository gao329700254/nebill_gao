# == Schema Information
# Schema version: 20181127095607
#
# Table name: expense_transportations
#
#  id         :integer          not null, primary key
#  amount     :integer
#  departure  :string
#  arrival    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExpenseTransportation < ApplicationRecord
  validates :amount, uniqueness: { scope: [:departure, :arrival] }
end
