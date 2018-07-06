# == Schema Information
# Schema version: 20180703032543
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
#  is_admin           :boolean          default(FALSE), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  role               :integer          default(10), not null
#  immediate_boss     :integer
#
# Indexes
#
#  index_users_on_provider_and_uid  (provider,uid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_f76f7dd8cc  (immediate_boss => users.id)
#

class User < ActiveRecord::Base
  extend Enumerize
  acts_as :employee
  acts_as_authentic

  has_many :members, through: :employee, class_name: 'UserMember'

  has_many :approval_users
  has_many :approvals, through: :approval_users

  enumerize :role, in: { general: 10, superior: 30 }, default: :general

  validates :provider, uniqueness: { scope: :uid }, allow_nil: true
  validates :role, presence: true

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
end
