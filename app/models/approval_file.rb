# == Schema Information
# Schema version: 20180703101036
#
# Table name: approval_files
#
#  id                :integer          not null, primary key
#  approval_id       :integer          not null
#  file              :string           not null
#  original_filename :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ApprovalFile < ApplicationRecord
  belongs_to :approval

  mount_uploader :file, BasicFileUploader

  def restore_cache!
    file.retrieve_from_cache!(file_cache) if file_cache.present?
  end
end
