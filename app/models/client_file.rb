# == Schema Information
# Schema version: 20180620035125
#
# Table name: client_files
#
#  id                :integer          not null, primary key
#  client_id         :integer          not null
#  file              :string           not null
#  original_filename :string           not null
#  type              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ClientFile < ActiveRecord::Base
  belongs_to :client
end
