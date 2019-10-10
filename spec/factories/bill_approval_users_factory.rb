FactoryBot.define do
  factory :bill_approval_user do
    role { 1 }
    status { 1 }
    comment { "MyString" }
    user { nil }
    bill { nil }
  end
end
