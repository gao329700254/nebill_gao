# == Schema Information
# Schema version: 20190912021755
#
# Table name: members
#
#  id                   :integer          not null, primary key
#  employee_id          :integer          not null
#  type                 :string           not null
#  unit_price           :integer
#  min_limit_time       :integer
#  max_limit_time       :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  working_rate         :float
#  project_id           :integer          not null
#  working_period_start :date
#  working_period_end   :date
#  man_month            :float
#
# Indexes
#
#  index_members_on_project_id  (project_id)
#  index_members_on_type        (type)
#
# Foreign Keys
#
#  fk_rails_...  (employee_id => employees.id) ON DELETE => cascade
#  fk_rails_...  (project_id => projects.id) ON DELETE => cascade
#

class PartnerMember < Member
  has_one :partner, through: :employee, source: :actable, source_type: 'Partner'
  belongs_to :project

  accepts_nested_attributes_for :partner

  validates :min_limit_time, numericality: { only_integer: true }, allow_nil: true
  validates :max_limit_time, numericality: { only_integer: true }, allow_nil: true
  validates :working_rate  , numericality: true, allow_nil: true
  validate :check_periods

  def check_periods
    return if working_period_end.nil? || working_period_start.nil?
    errors.add(:working_period_end, I18n.t('errors.messages.greater_than', count: '稼働開始')) if working_period_end < working_period_start
  end
end
