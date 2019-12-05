FactoryBot.define do
  factory :partner do
    sequence(:cd) { |n| "CD-#{n}" }
    name         { Faker::Name.name }
    email        { Faker::Internet.safe_email }

    trait :with_project do
      transient { project { create(:project) } }
      after :create do |user, evaluator|
        user.members.build(project: evaluator.project, unit_price: 1, working_rate: 0.6, min_limit_time: 1, max_limit_time: 2).save!
      end
    end
  end
end
