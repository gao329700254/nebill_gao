# == Schema Information
# Schema version: 20191007083806
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
#  role               :integer          default("general"), not null
#  default_allower    :integer
#  chatwork_id        :integer
#  chatwork_name      :string
#  crypted_password   :string
#  password_salt      :string
#  perishable_token   :string
#  is_chief           :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_provider_and_uid  (provider,uid) UNIQUE
#

class User < ApplicationRecord
  extend Enumerize
  acts_as :employee
  acts_as_authentic do |c|
    # FIXME: 警告がでるが変わりの手段がわからない
    c.merge_validates_length_of_password_field_options if: -> { password_changed? }
    c.disable_perishable_token_maintenance = true
  end

  has_many :members, through: :employee, class_name: 'UserMember'

  has_many :approval_users
  has_many :approvals, through: :approval_users

  has_many :expenses, foreign_key: :created_user_id
  has_many :expense_approvals

  has_many :expense_approval_users
  has_many :expense_approvals, through: :expense_approval_users

  enumerize :role, in: { general: 10, superior: 30, backoffice: 40, admin: 50, outer: 60 }, default: :general, scope: true

  validates :name, presence: true, on: :update
  validates :provider, uniqueness: { scope: :uid }, allow_nil: true
  validates :role, presence: true
  validates :default_allower, presence: true, on: :whencreate
  after_create :send_password_setting_email
  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def send_password_setting_email
    reset_perishable_token!
    UserMailer.password_setting(self).deliver_now
  end

  def self.find_by_smart_case_login_field(login)
    find_by(email: login)
  end

  def self.register_by!(auth)
    user = User.find_by!(email: auth.info.email)
    user.provider = auth.provider
    user.uid      = auth.uid
    user.name   ||= auth.info.name
    user.save!
    user
  end

  def join!(project)
    project.user_members.create!(employee_id: employee.id)
  end

  def self.chatwork_members_options
    Chatwork::Member.member_list.map { |m| m.values_at('name', 'account_id') }
  end
end
