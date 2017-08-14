FactoryGirl.define do
  factory :project do
    association :group, factory: :project_group

    sequence(:cd) { |n| "CD-#{n}" }
    name { Faker::App.name }
    contracted false

    factory :contracted_project do
      contracted true
      contract_on { Faker::Date.between(6.months.ago, 5.months.ago) }
      contract_type :lump_sum
      estimated_amount { rand(10) * (10 ** rand(3)) * 10_000 }
      is_using_ses false
      start_on    { Faker::Date.between(5.months.ago , 3.months.ago) }
      end_on      { Faker::Date.between(2.months.ago , 1.month.ago) }
      amount   { rand(10) * (10 ** rand(3)) * 10_000 }
      payment_type :bill_on_15th_and_payment_on_end_of_next_month
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

    factory :uncontracted_project do
      contracted false
      contract_on          nil
      contract_type        nil
      estimated_amount     nil
      is_using_ses         nil
      is_regular_contract  nil
      start_on             nil
      end_on               nil
      amount               nil
      payment_type         nil
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
