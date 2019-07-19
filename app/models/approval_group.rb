# == Schema Information
# Schema version: 20190627015639
#
# Table name: approval_groups
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_approval_groups_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_0ff4ca1016  (user_id => users.id)
#

class ApprovalGroup < ApplicationRecord
  has_many :approval_group_users
  has_many :users, through: :approval_group_users
  belongs_to :user

  accepts_nested_attributes_for :approval_group_users, allow_destroy: true, reject_if: :all_blank

  validates :name, :approval_group_users, presence: true
end
