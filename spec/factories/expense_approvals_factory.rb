FactoryBot.define do
  factory :expense_approval do
    total_amount { 1 }
    notes { "MyString" }
    status { 10 }
    expenses_number { 1 }
    expense_approval_user { [create(:expense_approval_user)] }
  end
end
