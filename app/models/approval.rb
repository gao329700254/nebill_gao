# == Schema Information
# Schema version: 20190912021755
#
# Table name: approvals
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  project_id      :string
#  created_user_id :integer          not null
#  notes           :string
#  approved_type   :string
#  approved_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer
#  category        :integer
#  approvaler_type :integer          default("user"), not null
#
# Indexes
#
#  index_approvals_on_approved_type_and_approved_id  (approved_type,approved_id)
#

class Approval < ApplicationRecord
  extend Enumerize
  has_many :approval_users
  has_many :users, through: :approval_users
  has_one :approval_approval_group
  has_one :approval_group, through: :approval_approval_group
  has_many :files, class_name: 'ApprovalFile', dependent: :destroy
  belongs_to :approved, polymorphic: true
  belongs_to :created_user, class_name: "User"
  accepts_nested_attributes_for :files, allow_destroy: true
  accepts_nested_attributes_for :approval_users, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :approval_approval_group, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, length: { maximum: 100 }
  validates :notes, length: { maximum: 2000 }
  validates :approval_approval_group, presence: true, if: -> { approvaler_type.group? }

  enumerize :status, in: { pending: 10, permission: 20, disconfirm: 30, invalid: 40 }, default: :pending, predicates: true
  enumerize :category, in: { contract_relationship: 10, new_client: 20, consumables: 30, other_purchasing: 40, other: 50 }, default: :other
  enumerize :approvaler_type, in: { user: 10, group: 20 }, default: :user

  scope :only_approval, -> { where(approved: nil, approved_id: nil) }
  scope :where_created_on, -> (created_on) { where(created_at: Date.strptime(created_on).beginning_of_day..Date.strptime(created_on).end_of_day) }
  scope :related_approval, -> (id) { joins(:approval_users).where('created_user_id = ? OR approval_users.user_id = ?', id, id) }

  after_touch :check_and_update_user_status, if: -> { approvaler_type.user? }
  after_touch :check_and_update_group_status, if: -> { approvaler_type.group? }

  def check_and_update_user_status
    Approval.no_touching do
      return update(status: :permission) if approval_users.all? { |i| i.status.permission? || i.status.reassignment? }
      return update(status: :disconfirm) if approval_users.any? { |i| i.status.disconfirm? }
    end
  end

  def check_and_update_group_status
    Approval.no_touching do
      return update(status: :permission) if approval_group.users.size == approval_users.size && approval_users.all? { |i| i.status.permission? }
      return update(status: :disconfirm) if approval_users.any? { |i| i.status.disconfirm? }
    end
  end

  def invalidate_approval_users
    approval_users.map(&:change_invalid)
  end

  def self.search_approval(current_user:, search_created_at: nil)
    result = if current_user.can?(:allread, Approval)
               Approval.all
             else
               Approval.related_approval(current_user.id)
                       .includes(:created_user)
             end

    search_created_at.present? ? result.where_created_on(search_created_at) : result
  end
end
