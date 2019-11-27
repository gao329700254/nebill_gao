# == Schema Information
# Schema version: 20191124083511
#
# Table name: bill_details
#
#  id            :integer          not null, primary key
#  content       :string
#  amount        :integer
#  display_order :integer          not null
#  bill_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_bill_details_on_bill_id  (bill_id)
#
# Foreign Keys
#
#  fk_rails_...  (bill_id => bills.id)
#

class BillDetail < ApplicationRecord
  belongs_to :bill

  validates :content      , presence: true, if: proc { |detail| detail.amount.present? }
  validates :content      , length: { maximum: 50 }
  validates :display_order, presence: true
end
