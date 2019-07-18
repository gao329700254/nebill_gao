# == Schema Information
# Schema version: 20190627015639
#
# Table name: approval_approval_groups
#
#  id                :integer          not null, primary key
#  approval_id       :integer
#  approval_group_id :integer
#  status            :integer          default(10), not null
#  comment           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_approval_approval_groups_on_approval_group_id  (approval_group_id)
#  index_approval_approval_groups_on_approval_id        (approval_id)
#
# Foreign Keys
#
#  fk_rails_4e8fa86d40  (approval_group_id => approval_groups.id)
#  fk_rails_fd5f9a9350  (approval_id => approvals.id)
#

class ApprovalApprovalGroup < ApplicationRecord
  extend Enumerize

  belongs_to :approval
  belongs_to :approval_group

  enumerize :status, in: { pending: 10, permission: 20, disconfirm: 30, reassignment: 40 }, default: :pending
end
