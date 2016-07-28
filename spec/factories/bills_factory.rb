FactoryGirl.define do
  factory :bill do
    project
    sequence(:key) { |n| "BILL-#{n}" }
    delivery_on    { Faker::Date.between(1.month.from_now, 2.months.from_now) }
    acceptance_on  { delivery_on + 5.days }
    payment_on     { acceptance_on + 1.day }
    bill_on        nil
    deposit_on     nil
    memo           { Faker::Lorem.sentence }
    amount         { rand(10) * (10 ** rand(3)) * 10_000 }
  end
end
