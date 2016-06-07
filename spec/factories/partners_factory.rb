FactoryGirl.define do
  factory :partner do
    name         { Faker::Name.name }
    email        { Faker::Internet.safe_email }
    company_name { Faker::Company.name }

    trait :with_project do
      transient { project { create(:contracted_project) } }
      after :create do |user, evaluator|
        user.members.build(project: evaluator.project).save!
      end
    end
  end
end
