# == Schema Information
# Schema version: 20190627015639
#
# Table name: approval_group_users
#
#  id                :integer          not null, primary key
#  approval_group_id :integer          not null
#  user_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_approval_group_users_on_approval_group_id  (approval_group_id)
#  index_approval_group_users_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_05ef483637  (user_id => users.id)
#  fk_rails_3198224b64  (approval_group_id => approval_groups.id)
#

class ApprovalGroupUser < ApplicationRecord
  belongs_to :approval_group
  belongs_to :user

  validates :user, uniqueness: { scope: :approval_group }
end
