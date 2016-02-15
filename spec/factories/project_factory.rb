FactoryGirl.define do
  factory :project do
    sequence(:key) { |n| "KEY-#{n}" }
    name { Faker::App.name }
    contracted false
    contract_on { Faker::Date.between(6.months.ago, 5.months.ago) }

    factory :contracted_project do
      contracted true
      contract_type :lump_sum
      is_using_ses true
      contractual_coverage :development
      start_on    { Faker::Date.between(5.months.ago    , 1.month.ago) }
      end_on      { Faker::Date.between(Time.zone.today , 5.months.from_now) }
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

    factory :un_contracted_project do
      contracted false
      contract_type        nil
      is_using_ses         nil
      contractual_coverage nil
      start_on             nil
      end_on               nil
      amount               nil
      billing_company_name    nil
      billing_department_name nil
      billing_personnel_names nil
      billing_address         nil
      billing_zip_code        nil
      billing_memo            nil
      orderer_company_name    nil
      orderer_department_name nil
      orderer_personnel_names nil
      orderer_address         nil
      orderer_zip_code        nil
      orderer_memo            nil
    end
  end
end
