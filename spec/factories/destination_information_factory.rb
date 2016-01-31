FactoryGirl.define do
  factory :destination_information do
    initialize_with do
      new(
        Faker::Company.name,
        Faker::Commerce.department,
        [Faker::Name.name, Faker::Name.name],
        "#{Faker::Address.city} #{Faker::Address.secondary_address}",
        Faker::Address.zip_code,
        Faker::Lorem.sentence,
      )
    end
  end
end
