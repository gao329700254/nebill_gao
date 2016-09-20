# == Schema Information
# Schema version: 20160823090016
#
# Table name: project_file_groups
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectFileGroup < ActiveRecord::Base
  belongs_to :project
  has_many :files, class_name: 'ProjectFile', foreign_key: :file_group_id

  validates :name, presence: true
end