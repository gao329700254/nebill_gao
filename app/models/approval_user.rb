# == Schema Information
# Schema version: 20181018043025
#
# Table name: approval_users
#
#  id          :integer          not null, primary key
#  approval_id :integer
#  user_id     :integer
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  comment     :string
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
  extend Enumerize
  belongs_to :approval
  belongs_to :user

  validates :comment  , length: { maximum: 200 }

  enumerize :status, in: { pending: 10, permission: 20, disconfirm: 30, reassignment: 40 }, default: :pending

  scope :id_in, -> (ids) { where(user_id: ids) if ids.present? }
  scope :with_permission, -> { where(status: 20) }
end
