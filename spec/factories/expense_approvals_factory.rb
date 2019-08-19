FactoryBot.define do
  factory :expense_approval do
    total_amount { (rand(1..10) * 100) }
    notes { Faker::Lorem.sentence }
    status { 10 }
    expenses_number { rand(1..10) }
    expense_approval_user { [create(:expense_approval_user)] }
  end
end
