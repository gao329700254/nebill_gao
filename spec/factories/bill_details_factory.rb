FactoryBot.define do
  factory :bill_detail do
    content { "MyString" }
    amount { 1 }
    sequence(:display_order) { |n| n }
    bill { nil }
  end
end
