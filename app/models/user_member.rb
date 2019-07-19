# == Schema Information
# Schema version: 20190627015639
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
#  fk_rails_1e30d6a7f9  (employee_id => employees.id)
#  fk_rails_7054080f33  (project_id => projects.id)
#

class UserMember < Member
  has_one :user, through: :employee, source: :actable, source_type: 'User'
  belongs_to :project

  validates :unit_price, :working_rate, :min_limit_time, :max_limit_time, absence: true
  validate :check_periods

  def check_periods
    return if working_period_end.nil? || working_period_start.nil?
    errors.add(:working_period_end, I18n.t('errors.messages.greater_than', count: '稼働開始')) if working_period_end < working_period_start
  end
end
