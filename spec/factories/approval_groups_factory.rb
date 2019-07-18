FactoryBot.define do
  factory :approval_group do
    name { Faker::Lorem.sentence }
    after(:build) do |approval_group|
      approval_group.users << create(:user)
    end
  end
end
