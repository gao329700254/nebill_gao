# == Schema Information
# Schema version: 20181127095607
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  provider           :string
#  uid                :string
#  persistence_token  :string           not null
#  login_count        :integer          default(0), not null
#  failed_login_count :integer          default(0), not null
#  current_login_at   :datetime
#  last_login_at      :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  role               :integer          default(10), not null
#  default_allower    :integer
#  chatwork_id        :integer
#  chatwork_name      :string
#
# Indexes
#
#  index_users_on_provider_and_uid  (provider,uid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_f76f7dd8cc  (default_allower => users.id)
#

class User < ActiveRecord::Base
  extend Enumerize
  acts_as :employee
  acts_as_authentic

  has_many :members, through: :employee, class_name: 'UserMember'

  has_many :approval_users
  has_many :approvals, through: :approval_users

  has_many :expenses
  has_many :expense_approvals

  has_many :expense_approval_users
  has_many :expense_approvals, through: :expense_approval_users

  enumerize :role, in: { general: 10, superior: 30, backoffice: 40, admin: 50 }, default: :general

  validates :name, presence: true, on: :update
  validates :provider, uniqueness: { scope: :uid }, allow_nil: true
  validates :role, presence: true
  validates :default_allower, presence: true, on: :whencreate

  def self.register_by!(auth)
    user = User.find_by!(email: auth.info.email)
    user.provider = auth.provider
    user.uid      = auth.uid
    user.name     = auth.info.name
    user.save!
    user
  end

  def join!(bill)
    bill.user_members.create!(employee_id: employee.id)
  end

  def self.chatwork_members_options
    Chatwork::Member.member_list.map { |m| m.values_at('name', 'account_id') }
  end
end
