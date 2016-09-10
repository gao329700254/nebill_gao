FactoryGirl.define do
  factory :client do
    sequence(:key) { |n| "KEY-#{n}" }
    company_name    { Faker::Company.name }
    department_name { Faker::Commerce.department }
    address         { "#{Faker::Address.city} #{Faker::Address.secondary_address}" }
    zip_code        { Faker::Address.zip_code }
    phone_number    { Faker::PhoneNumber.phone_number }
    memo            { Faker::Lorem.sentence }
  end
end
