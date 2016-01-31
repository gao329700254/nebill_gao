FactoryGirl.define do
  factory :project do
    sequence(:key) { |n| "KEY-#{n}" }
    name { Faker::App.name }
    contract_type :lump_sum
    start_on { Faker::Date.between(5.months.ago    , 1.month.ago)      }
    end_on   { Faker::Date.between(Time.zone.today , 5.months.from_now) }
    amount   { rand(10) * (10 ** rand(3)) * 10_000 }
    billing_company_name    { Faker::Company.name }
    billing_department_name { Faker::Commerce.department }
    billing_personnel_names { [Faker::Name.name, Faker::Name.name] }
    billing_address         { "#{Faker::Address.city} #{Faker::Address.secondary_address}" }
    billing_zip_code        { Faker::Address.zip_code }
    billing_memo            { Faker::Lorem.sentence }
    orderer_company_name    { Faker::Company.name }
    orderer_department_name { Faker::Commerce.department }
    orderer_personnel_names { [Faker::Name.name, Faker::Name.name] }
    orderer_address         { "#{Faker::Address.city} #{Faker::Address.secondary_address}" }
    orderer_zip_code        { Faker::Address.zip_code }
    orderer_memo            { Faker::Lorem.sentence }
  end
end
