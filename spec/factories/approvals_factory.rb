FactoryBot.define do
  factory :approval do
    name              { Faker::Lorem.sentence }
    category          { [10, 20, 30, 40, 50][rand(0..4)] }
    notes             { Faker::Lorem.sentence }
    created_user_id   { nil }

    factory :status_of_approval_is_disconfirm do
      status { 30 }
    end
    trait :user_approval do
      approvaler_type { 10 }

      after(:build) do |approval|
        approval.users << create(:user)
      end
    end

    trait :group_approval do
      approvaler_type { 20 }

      after(:build) do |approval|
        approval.approval_group = create(:approval_group)
      end
    end
  end
end
