FactoryGirl.define do
  factory :expense_approval do
    total_amount 1
    note "MyString"
    status 1
    created_user_id 1
    expenses_number 1
  end

end
