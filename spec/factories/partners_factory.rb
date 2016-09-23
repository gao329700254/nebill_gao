FactoryGirl.define do
  factory :partner do
    name         { Faker::Name.name }
    email        { Faker::Internet.safe_email }
    company_name { Faker::Company.name }

    trait :with_project do
      transient { project { create(:contracted_project) } }
      after :create do |user, evaluator|
        user.members.build(project: evaluator.project, unit_price: 1, min_limit_time: 1, max_limit_time: 2).save!
      end
    end
  end
end
