# == Schema Information
# Schema version: 20190911034541
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
# Foreign Keys
#
#  fk_rails_...  (expense_id => expenses.id) ON DELETE => nullify
#

class ExpenseFile < ApplicationRecord
  belongs_to :expense

  mount_uploader :file, BasicFileUploader
end
