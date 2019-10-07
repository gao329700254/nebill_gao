# == Schema Information
# Schema version: 20191007083806
#
# Table name: expense_files
#
#  id                :integer          not null, primary key
#  expense_id        :integer
#  file              :string
#  original_filename :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ExpenseFile < ApplicationRecord
  belongs_to :expense

  mount_uploader :file, BasicFileUploader
end
