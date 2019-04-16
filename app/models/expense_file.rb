# == Schema Information
# Schema version: 20190416043726
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
#  fk_rails_024476420e  (expense_id => expenses.id)
#

class ExpenseFile < ActiveRecord::Base
  belongs_to :expense

  mount_uploader :file, ExpenseFileUploader
end
