# == Schema Information
# Schema version: 20161003063433
#
# Table name: project_files
#
#  id            :integer          not null, primary key
#  project_id    :integer          not null
#  file          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  file_group_id :integer
#
# Foreign Keys
#
#  fk_rails_c26fbba4b3  (project_id => projects.id)
#

class ProjectFile < ActiveRecord::Base
  belongs_to :project
  belongs_to :group, class_name: 'ProjectFileGroup', foreign_key: :file_group_id

  mount_uploader :file, ProjectFileUploader

  validates :file, presence: true
end
