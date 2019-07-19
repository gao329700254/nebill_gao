# == Schema Information
# Schema version: 20190627015639
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
#  status          :integer
#  is_valid        :boolean          default(TRUE)
#

class Client < ApplicationRecord
  extend Enumerize
  has_many :approvals, as: :approved
  has_many :files, class_name: 'ClientFile', dependent: :destroy
  accepts_nested_attributes_for :files, allow_destroy: true

  has_paper_trail

  validates :cd, uniqueness: { case_sensitive: false }, if: :cd?
  validates :company_name, presence: true

  before_save { cd.upcase! if cd.present? }
  before_save :set_cd, unless: :cd?

  enumerize :status, in: { approval_pending: 10, waiting: 20, published: 30 }, default: :waiting

  def set_cd
    max_cd = Client.all.pluck(:cd).compact.map { |cd| cd.gsub(/[^\d]/, "").to_i if cd.start_with?("CD") }.compact.max if Client.all.present?
    self.cd = max_cd ? "CD-" + (max_cd + 1).to_s : "CD-1"
  end
end
