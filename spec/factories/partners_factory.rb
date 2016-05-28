FactoryGirl.define do
  factory :partner do
    name         { Faker::Name.name }
    email        { Faker::Internet.safe_email }
    company_name { Faker::Company.name }
  end
end
