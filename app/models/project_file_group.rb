# == Schema Information
# Schema version: 20170801021317
#
# Table name: project_file_groups
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Foreign Keys
#
#  fk_rails_149964afbb  (project_id => projects.id)
#

class ProjectFileGroup < ActiveRecord::Base
  belongs_to :project
  has_many :files, class_name: 'ProjectFile', foreign_key: :file_group_id

  validates :name, presence: true
end
