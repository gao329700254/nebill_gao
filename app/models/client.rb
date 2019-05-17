# == Schema Information
# Schema version: 20181218054454
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
#

class Client < ActiveRecord::Base
  extend Enumerize
  has_many :approvals, as: :approved
  has_many :files, class_name: 'ClientFile', dependent: :destroy
  accepts_nested_attributes_for :files, allow_destroy: true

  has_paper_trail

  validates :cd, uniqueness: { case_sensitive: false }, if: :cd?
  validates :company_name, presence: true
  validates :files, presence: true, on: :create

  before_save { cd.upcase! if cd.present? }
  before_save :set_cd, unless: :cd?
  after_create :create_approval

  enumerize :status, in: { approval_pending: 10, waiting_for_basic_contract: 20, published: 30 }

  def set_cd
    max_cd = Client.all.pluck(:cd).compact.map { |cd| cd.gsub(/[^\d]/, "").to_i if cd.start_with?("CD") }.compact.max if Client.all.present?
    self.cd = max_cd ? "CD-" + (max_cd + 1).to_s : "CD-1"
  end

  def create_approval
    approval_params = {
      name: Client.human_attribute_name(:approval_name, comany: company_name),
      created_user_id: UserSession.find.user.id,
      notes: memo,
      category: 20,
      approved_id: id,
      approved_type: "Client",
    }
    create_params = { user_id: 6 }
    if ::Approvals::CreateApprovalService.new(approval_params: approval_params, create_params: create_params).execute
      return self
    end
    fail
  end
end
