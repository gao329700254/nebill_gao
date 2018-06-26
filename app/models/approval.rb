# == Schema Information
# Schema version: 20180620035125
#
# Table name: approvals
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  project_id      :string
#  created_user_id :integer          not null
#  notes           :string
#  approved_id     :integer
#  approved_type   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_approvals_on_approved_type_and_approved_id  (approved_type,approved_id)
#

class Approval < ActiveRecord::Base
  has_many :approval_users
  has_many :users
  belongs_to :approved, polymorphic: true
end
