FactoryBot.define do
  factory :approval_user do
    approval
    user
    status { 10 }
  end
end
