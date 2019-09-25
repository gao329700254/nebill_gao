FactoryBot.define do
  factory :project do
    association :group, factory: :project_group

    sequence(:cd) { |n| "#{rand(11..20)}D#{n.to_s.rjust(3, '0')}" }
    name { Faker::App.name }
    contracted { false }
    contract_on { Faker::Date.between(6.months.ago, 5.months.ago) }
    contract_type { :lump_sum }
    estimated_amount { (rand(1..10) * (10 ** rand(1..3)) * 10_000).to_s }

    factory :contracted_project do
      contracted { true }
      unprocessed { false }
      status { :receive_order }
      is_using_ses { false }
      start_on    { Faker::Date.between(5.months.ago , 3.months.ago) }
      end_on      { Faker::Date.between(2.months.ago , 1.month.ago) }
      amount   { (rand(1..10) * (10 ** rand(1..3)) * 10_000).to_s }
      payment_type  { :bill_on_15th_and_payment_on_end_of_next_month }
      billing_company_name    { Faker::Company.name }
      billing_department_name { Faker::Commerce.department }
      billing_personnel_names { [Faker::Name.name, Faker::Name.name] }
      billing_address         { "#{Faker::Address.city} #{Faker::Address.secondary_address}" }
      billing_zip_code        { Faker::Address.zip_code }
      billing_phone_number    { Faker::PhoneNumber.phone_number }
      billing_memo            { Faker::Lorem.sentence }
      orderer_company_name    { Faker::Company.name }
      orderer_department_name { Faker::Commerce.department }
      orderer_personnel_names { [Faker::Name.name, Faker::Name.name] }
      orderer_address         { "#{Faker::Address.city} #{Faker::Address.secondary_address}" }
      orderer_zip_code        { Faker::Address.zip_code }
      orderer_phone_number    { Faker::PhoneNumber.phone_number }
      orderer_memo            { Faker::Lorem.sentence }
    end

    factory :uncontracted_project do
      contracted { false }
      unprocessed { false }
      status               { nil }
      is_using_ses         { nil }
      is_regular_contract  { nil }
      start_on             { nil }
      end_on               { nil }
      amount               { nil }
      payment_type         { nil }
      billing_company_name    { nil }
      billing_department_name { nil }
      billing_personnel_names { nil }
      billing_address         { nil }
      billing_zip_code        { nil }
      billing_phone_number    { nil }
      billing_memo            { nil }
      orderer_company_name    { nil }
      orderer_department_name { nil }
      orderer_personnel_names { nil }
      orderer_address         { nil }
      orderer_zip_code        { nil }
      orderer_phone_number    { nil }
      orderer_memo            { nil }
    end
  end
end
