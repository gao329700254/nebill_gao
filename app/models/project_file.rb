# == Schema Information
# Schema version: 20190912021755
#
# Table name: project_files
#
#  id                :integer          not null, primary key
#  project_id        :integer          not null
#  file              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_group_id     :integer
#  original_filename :string           not null
#  file_type         :integer
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id) ON DELETE => cascade
#

class ProjectFile < ApplicationRecord
  extend Enumerize
  belongs_to :project
  belongs_to :group, class_name: 'ProjectFileGroup', foreign_key: :file_group_id
  has_paper_trail meta: { project_id: :project_id }

  mount_uploader :file, BasicFileUploader

  enumerize :file_type, in: { default: 10, purchase: 20 }, default: :default

  validates :file             , presence: true
  validates :original_filename, presence: true
end
