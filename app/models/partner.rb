# == Schema Information
# Schema version: 20160524030515
#
# Table name: partners
#
#  id           :integer          not null, primary key
#  company_name :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Partner < ActiveRecord::Base
  acts_as :employee

  validates :company_name, presence: true
end
