# == Schema Information
# Schema version: 20191007052937
#
# Table name: bill_applicants
#
#  id         :integer          not null, primary key
#  comment    :string
#  user_id    :integer
#  bill_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bill_applicants_on_bill_id  (bill_id)
#  index_bill_applicants_on_user_id  (user_id)
#

class BillApplicant < ApplicationRecord
  belongs_to :user
  belongs_to :bill

  validates :comment, length: { maximum: 200 }
  validates :user_id, presence: true
  validates :bill_id, presence: true
end
