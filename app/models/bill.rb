# == Schema Information
# Schema version: 20160412071317
#
# Table name: bills
#
#  id            :integer          not null, primary key
#  project_id    :integer          not null
#  key           :string           not null
#  delivery_on   :date             not null
#  acceptance_on :date             not null
#  payment_type  :string           not null
#  payment_on    :date             not null
#  bill_on       :date
#  deposit_on    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
  validates :delivery_on  , presence: true
  validates :acceptance_on, presence: true
  validates :payment_type , presence: true
  validates :payment_on   , presence: true

  # TODO(ishida): 支払日自動計算機能実装時に網羅
  enumerize :payment_type, in: %w(
    end_of_the_delivery_date_next_month
    end_of_the_acceptance_on_date_next_month
    15th_of_the_delivery_date_month_after_next
    15th_of_the_acceptance_date_month_after_next
  )

  before_save { key.upcase! }
end
