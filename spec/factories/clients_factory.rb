FactoryGirl.define do
  factory :client do
    sequence(:cd)   { |n| "CD-#{n}" }
    company_name    { Faker::Company.name }
    department_name { Faker::Commerce.department }
    address         { "#{Faker::Address.city} #{Faker::Address.secondary_address}" }
    zip_code        { Faker::Address.zip_code }
    phone_number    { Faker::PhoneNumber.phone_number }
    memo            { Faker::Lorem.sentence }

    after(:build) do |client|
      client.files << build(:client_file, :nda, client: client)
    end
  end
end
