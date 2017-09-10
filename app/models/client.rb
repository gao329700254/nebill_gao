# == Schema Information
# Schema version: 20170721074829
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  cd              :string
#  company_name    :string           not null
#  department_name :string
#  address         :string
#  zip_code        :string
#  phone_number    :string
#  memo            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Client < ActiveRecord::Base
  has_paper_trail

  validates :cd, uniqueness: { case_sensitive: false }, if: :cd?
  validates :company_name, presence: true

  before_save { cd.upcase! if cd.present? }
  before_save :set_cd, unless: :cd?

  def set_cd
    max_cd = Client.all.pluck(:cd).compact.map { |cd| cd.gsub(/[^\d]/, "").to_i }.max if Client.all.present?
    self.cd = max_cd ? "CD-" + (max_cd + 1).to_s : "CD-1"
  end
end
