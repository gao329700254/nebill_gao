# == Schema Information
# Schema version: 20180912093635
#
# Table name: default_expense_items
#
#  id              :integer          not null, primary key
#  name            :string
#  display_name    :string
#  standard_amount :integer
#  is_routing      :boolean
#  is_quantity     :boolean
#  note            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_receipt      :boolean
#

class DefaultExpenseItem < ApplicationRecord
  has_many :expenses
end
