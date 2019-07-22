FactoryBot.define do
  factory :approval do
    name              { Faker::Lorem.sentence }
    category          do
      [:contract_relationship,
       :new_client,
       :consumables,
       :other_purchasing,
       :other][rand(0..4)]
    end
    notes             { Faker::Lorem.sentence }
    created_user_id   { nil }

    factory :status_of_approval_is_disconfirm do
      status { :disconfirm }
    end
    trait :user_approval do
      approvaler_type { :user }

      after(:build) do |approval|
        approval.users << create(:user)
      end
    end

    trait :group_approval do
      approvaler_type { :group }

      after(:build) do |approval|
        approval.approval_group = create(:approval_group)
      end
    end
  end
end
