FactoryGirl.define do
  factory :user do
    provider 'google_oauth2'
    uid      { SecureRandom.hex }
    name     { Faker::Name.name }
    email    { Faker::Internet.safe_email }
    persistence_token { Faker::Lorem.characters(10) }
    is_admin false

    factory :admin_user do
      is_admin true
    end

    factory :un_register_user do
      provider nil
      uid      nil
      name     nil
    end

    trait :with_project do
      transient { project { create(:contracted_project) } }
      after :create do |user, evaluator|
        user.members.build(project: evaluator.project).save!
      end
    end
  end
end
