# == Schema Information
# Schema version: 20160805140435
#
# Table name: project_files
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  file       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectFile < ActiveRecord::Base
  belongs_to :project

  mount_uploader :file, ProjectFileUploader

  validates :file, presence: true
end
