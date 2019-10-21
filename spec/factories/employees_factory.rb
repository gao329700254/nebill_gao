FactoryBot.define do
  factory :employee do
    sequence(:actable_id){ |n| n }
    sequence(:actable_type){ 'User' }
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
