FactoryGirl.define do
  factory :partner do
    sequence(:cd) { |n| "CD-#{n}" }
    name         { Faker::Name.name }
    email        { Faker::Internet.safe_email }
    company_name { Faker::Company.name }
    address      { "#{Faker::Address.city} #{Faker::Address.secondary_address}" }
    zip_code     { Faker::Address.zip_code }
    phone_number { Faker::PhoneNumber.phone_number }

    trait :with_bill do
      transient { bill { create(:bill) } }
      after :create do |user, evaluator|
        user.members.build(bill: evaluator.bill, unit_price: 1, working_rate: 0.6, min_limit_time: 1, max_limit_time: 2).save!
      end
    end
  end
end
