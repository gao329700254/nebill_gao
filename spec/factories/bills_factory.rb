FactoryBot.define do
  factory :bill do
    project
    sequence(:cd)           { |n| "BILL-#{n}" }
    delivery_on             { Faker::Date.between(2.months.ago, 3.months.ago) }
    acceptance_on           { delivery_on + 5.days }
    payment_type            { Project.payment_type.values[rand(0..7)] }
    bill_on                 { acceptance_on + 1.month }
    expected_deposit_on     { acceptance_on + 2.months }
    memo                    { Faker::Lorem.sentence }
    amount                  { rand(10) * (10 ** rand(3)) * 10_000 }
    status                  { "unapplied" }
  end
end
