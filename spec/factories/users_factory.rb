FactoryGirl.define do
  factory :user do
    provider 'google_oauth2'
    uid      { SecureRandom.hex }
    name     { Faker::Name.name }
    email    { Faker::Internet.safe_email }
    persistence_token { Faker::Lorem.characters(10) }
    role     :general
    is_admin false

    factory :admin_user do
      is_admin true
    end

    factory :un_register_user do
      provider nil
      uid      nil
      name     nil
    end

    trait :with_bill do
      transient { bill { create(:bill) } }
      after :create do |user, evaluator|
        user.members.build(bill: evaluator.bill).save!
      end
    end
  end
end
