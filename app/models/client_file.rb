# == Schema Information
# Schema version: 20190108060032
#
# Table name: client_files
#
#  id                :integer          not null, primary key
#  client_id         :integer          not null
#  file              :string           not null
#  original_filename :string           not null
#  file_type         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  legal_check       :boolean          default(FALSE)
#

class ClientFile < ActiveRecord::Base
  extend Enumerize
  belongs_to :client

  mount_uploader :file, BasicFileUploader

  validates :legal_check, presence: {
    message: -> (_rec, _data) { I18n.t('errors.messages.presence_check_box') },
  }

  enumerize :file_type, in: { nda: 10, basic_contract: 20 }
end
