# == Schema Information
# Schema version: 20160728084638
#
# Table name: bills
#
#  id            :integer          not null, primary key
#  project_id    :integer          not null
#  key           :string           not null
#  delivery_on   :date             not null
#  acceptance_on :date             not null
#  payment_on    :date             not null
#  bill_on       :date
#  deposit_on    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  memo          :text
#  amount        :integer          default(0), not null
#
# Indexes
#
#  index_bills_on_key  (key) UNIQUE
#

class Bill < ActiveRecord::Base
  extend Enumerize

  belongs_to :project

  validates :project      , presence: true
  validates :key          , presence: true, uniqueness: { case_sensitive: false }
  validates :amount       , presence: true
  validates :delivery_on  , presence: true
  validates :acceptance_on, presence: true
  validates :payment_on   , presence: true

  before_save { key.upcase! }
end
