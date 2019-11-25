# == Schema Information
# Schema version: 20191124083511
#
# Table name: bill_details
#
#  id         :integer          not null, primary key
#  content    :string           not null
#  amount     :integer
#  bill_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
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

  validates :content, presence: true
end
