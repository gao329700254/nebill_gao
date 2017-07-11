# == Schema Information
# Schema version: 20170711122708
#
# Table name: bills
#
#  id            :integer          not null, primary key
#  project_id    :integer          not null
#  cd            :string           not null
#  delivery_on   :date             not null
#  acceptance_on :date             not null
#  bill_on       :date
#  deposit_on    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  memo          :text
#  amount        :integer          default(0), not null
#  payment_type  :string
#
# Indexes
#
#  index_bills_on_cd  (cd) UNIQUE
#
# Foreign Keys
#
#  fk_rails_9a464041fd  (project_id => projects.id)
#

class Bill < ActiveRecord::Base
  extend Enumerize

  belongs_to :project

  validates :project      , presence: true
  validates :cd           , presence: true, uniqueness: { case_sensitive: false }
  validates :amount       , presence: true
  validates :delivery_on  , presence: true
  validates :acceptance_on, presence: true
  validate  :bill_on_cannot_predate_delivery_on
  validate  :bill_on_cannot_predate_acceptance_on

  before_save { cd.upcase! }

  def bill_on_cannot_predate_delivery_on
    return if bill_on.nil?
    errors.add(:bill_on, I18n.t('errors.messages.wrong_bill_on_predate_delivery_on')) if bill_on < delivery_on
  end

  def bill_on_cannot_predate_acceptance_on
    return if bill_on.nil?
    errors.add(:bill_on, I18n.t('errors.messages.wrong_bill_on_predate_acceptance_on')) if bill_on < acceptance_on
  end
end
