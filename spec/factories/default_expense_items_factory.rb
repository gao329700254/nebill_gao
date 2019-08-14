FactoryBot.define do
  factory :default_expense_item do
    name { Faker::Lorem.sentence }
    display_name { Faker::Lorem.sentence }
    standard_amount { 0 }
    is_routing { false }
    is_quantity { false }
    note { Faker::Lorem.sentence }
  end
end
