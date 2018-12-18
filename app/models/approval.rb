# == Schema Information
# Schema version: 20180720081012
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
#  status          :integer
#  category        :integer
#
# Indexes
#
#  index_approvals_on_approved_type_and_approved_id  (approved_type,approved_id)
#

class Approval < ActiveRecord::Base
  extend Enumerize
  has_many :approval_users
  has_many :users, through: :approval_users
  has_many :files, class_name: 'ApprovalFile', dependent: :destroy
  belongs_to :approved, polymorphic: true
  belongs_to :created_user, class_name: "User"
  accepts_nested_attributes_for :files, allow_destroy: true

  validates :name   , presence: true, length: { maximum: 100 }
  validates :notes  , length: { maximum: 2000 }

  enumerize :status, in: { pending: 10, permission: 20, disconfirm: 30, invalid: 40 }, default: :pending
  enumerize :category, in: { contract_relationship: 10, new_client: 20, consumables: 30, other_purchasing: 40, other: 50 }, default: :other

  scope :only_approval, -> { where(approved: nil, approved_id: nil) }
  scope :where_created_on, -> (created_on) { where(created_at: Date.strptime(created_on).beginning_of_day..Date.strptime(created_on).end_of_day) }
  scope :related_approval, -> (id) { where('created_user_id = ? OR approval_users.user_id = ?', id, id) }

  class << self
    def related_approval_where_created_on(id, created_at)
      related_approval(id).where_created_at(created_at)
    end
  end
end
