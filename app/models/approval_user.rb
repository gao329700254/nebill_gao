# == Schema Information
# Schema version: 20180703032543
#
# Table name: approval_users
#
#  id          :integer          not null, primary key
#  approval_id :integer
#  user_id     :integer
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_approval_users_on_approval_id              (approval_id)
#  index_approval_users_on_approval_id_and_user_id  (approval_id,user_id) UNIQUE
#  index_approval_users_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_79135381b3  (approval_id => approvals.id)
#  fk_rails_c7d21d10af  (user_id => users.id)
#

class ApprovalUser < ActiveRecord::Base
  belongs_to :approvals
  belongs_to :users
end
