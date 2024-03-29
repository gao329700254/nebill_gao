# == Schema Information
# Schema version: 20191031050805
#
# Table name: bill_applicants
#
#  id         :integer          not null, primary key
#  comment    :string
#  user_id    :integer          not null
#  bill_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bill_applicants_on_bill_id  (bill_id)
#  index_bill_applicants_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (bill_id => bills.id)
#  fk_rails_...  (user_id => users.id)
#

class BillApplicant < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :bill, required: true

  validates :comment, length: { maximum: 200 }
end
