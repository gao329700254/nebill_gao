FactoryGirl.define do
  factory :approval do
    name              { Faker::Lorem.sentence }
    category          { [10, 20, 30, 40, 50][rand(0..4)] }
    notes             { Faker::Lorem.sentence }
    created_user_id   nil

    factory :status_of_approval_is_disconfirm do
      status 30
    end
  end
end
