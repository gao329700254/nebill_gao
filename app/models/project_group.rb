# == Schema Information
# Schema version: 20160223061843
#
# Table name: project_groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectGroup < ActiveRecord::Base
  has_many :projects, dependent: :nullify, foreign_key: :group_id

  validates :name, presence: true
end
