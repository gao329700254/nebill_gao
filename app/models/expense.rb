# == Schema Information
# Schema version: 20181018043025
#
# Table name: expenses
#
#  id                  :integer          not null, primary key
#  default_id          :integer
#  use_date            :date
#  amount              :integer
#  depatture_location  :string
#  arrival_location    :string
#  quantity            :integer
#  notes               :string
#  payment_type        :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  created_user_id     :integer
#  expense_approval_id :integer
#
# Foreign Keys
#
#  fk_rails_5ae686df24  (expense_approval_id => expense_approvals.id)
#  fk_rails_e2984c1aec  (created_user_id => users.id)
#  fk_rails_fe4b1121aa  (default_id => default_expense_items.id)
#

class Expense < ActiveRecord::Base
  extend Enumerize
  has_many :file, class_name: 'ExpenseFile', dependent: :destroy

  belongs_to :expense_approval
  belongs_to :created_user, class_name: "User"
  belongs_to :default, class_name: 'DefaultExpenseItem', foreign_key: 'default_id'

  accepts_nested_attributes_for :file, allow_destroy: true

  validates :use_date   , presence: true
  validates :default_id   , presence: true
  validates :amount   , presence: true

  enumerize :payment_type, in: { person_rebuilding: 10, invoice: 20, corporate_card: 30 }, default: :person_rebuilding

  scope :between, lambda { |start_on, end_on|
    where(Expense.arel_table[:use_date].gteq(start_on)).where(Expense.arel_table[:use_date].lteq(end_on))
  }
  scope :approval_id_not_nil, -> { where.not(expense_approval_id: nil) }
  scope :gteq_start_on, -> (start_on) { where(Expense.arel_table[:use_date].gteq(start_on)) }
  scope :lteq_end_on, -> (end_on) { where(Expense.arel_table[:use_date].lteq(end_on)) }

  def self.to_csv(headers)
    CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.find_each do |exp|
        csv << [exp.expense_approval_id,
                exp.expense_approval.status_text,
                exp.expense_approval.created_at.strftime("%Y-%m-%d %H:%M"),
                exp.expense_approval.created_user.name,
                exp.expense_approval.expense_approval_user.last.user.name,
                exp.use_date,
                exp.default.name,
                exp.amount,
                exp.depatture_location,
                exp.arrival_location,
                receipt(exp),
                exp.notes,
                exp.payment_type_text]
      end
    end
  end

  def self.receipt(exp)
    if exp.default.is_receipt
      Expense.human_attribute_name(:file_exists)
    else
      Expense.human_attribute_name(:file_not_exists)
    end
  end
end