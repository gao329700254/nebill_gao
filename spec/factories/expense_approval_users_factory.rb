FactoryBot.define do
  factory :expense_approval_user do
    user { create(:user) }
  end
end
