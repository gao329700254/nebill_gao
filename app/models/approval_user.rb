# == Schema Information
# Schema version: 20190912021755
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
#  fk_rails_...  (approval_id => approvals.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#

class ApprovalUser < ApplicationRecord
  extend Enumerize
  belongs_to :approval, touch: true
  belongs_to :user

  validates :user_id, presence: true
  validates :comment  , length: { maximum: 200 }

  enumerize :status, in: { pending: 10, permission: 20, disconfirm: 30, reassignment: 40, invalid: 50 }, default: :pending

  scope :id_in, -> (ids) { where(user_id: ids) if ids.present? }
  scope :with_permission, -> { where(status: 20) }
  scope :with_disconfirm, -> { where(status: 30) }

  def change_invalid
    self.status = :invalid
  end
end
