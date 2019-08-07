FactoryBot.define do
  factory :expense do
    use_date           { Faker::Date.between(2.months.ago , 1.month.ago) }
    amount             { (rand(1..10) * 100) }
    depatture_location { '' }
    arrival_location   { '' }
    quantity           { 0 }
    notes               { Faker::Lorem.sentence }
    payment_type       { 10 }

    after(:build) do |expense|
      expense.default_id = create(:default_expense_item).id
    end
  end
end
