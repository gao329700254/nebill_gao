# == Schema Information
# Schema version: 20160524025023
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
#
# Indexes
#
#  index_users_on_provider_and_uid  (provider,uid) UNIQUE
#

class User < ActiveRecord::Base
  acts_as :employee
  acts_as_authentic

  validates :provider, uniqueness: { scope: :uid }, allow_nil: true

  def self.register_by!(auth)
    user = User.find_by!(email: auth.info.email)
    user.provider = auth.provider
    user.uid      = auth.uid
    user.name     = auth.info.name
    user.save!
    user
  end
end
