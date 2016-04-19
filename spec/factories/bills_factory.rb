FactoryGirl.define do
  factory :bill do
    project
    sequence(:key) { |n| "BILL-#{n}" }
    delivery_on    { Faker::Date.between(1.month.from_now, 2.months.from_now) }
    acceptance_on  { delivery_on + 5.days }
    payment_type   'end_of_the_delivery_date_next_month'
    payment_on     { acceptance_on + 1.day }
    bill_on        nil
    deposit_on     nil
  end
end
