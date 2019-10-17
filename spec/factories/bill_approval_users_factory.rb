FactoryBot.define do
  factory :bill_approval_user do
    role { "primary" }
    status { "unapplied" }
    comment { "MyString" }
    user { nil }
    bill { nil }
  end
end
