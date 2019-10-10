# == Schema Information
# Schema version: 20191007083806
#
# Table name: approval_approval_groups
#
#  id                :integer          not null, primary key
#  approval_id       :integer
#  approval_group_id :integer
#  status            :integer          default("pending"), not null
#  comment           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_approval_approval_groups_on_approval_group_id  (approval_group_id)
#  index_approval_approval_groups_on_approval_id        (approval_id)
#

class ApprovalApprovalGroup < ApplicationRecord
  extend Enumerize

  belongs_to :approval
  belongs_to :approval_group

  enumerize :status, in: { pending: 10, permission: 20, disconfirm: 30, reassignment: 40 }, default: :pending
end
