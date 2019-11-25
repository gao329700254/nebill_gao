FactoryBot.define do
  factory :bill_detail do
    content { "MyString" }
    amount { 1 }
    bill { nil }
  end
end
