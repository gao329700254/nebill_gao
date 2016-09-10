# == Schema Information
# Schema version: 20160905090519
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  key             :string           not null
#  company_name    :string
#  department_name :string
#  address         :string
#  zip_code        :string
#  phone_number    :string
#  memo            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Client < ActiveRecord::Base
  validates :key, presence: true, uniqueness: { case_sensitive: false }

  before_save { key.upcase! }
end
