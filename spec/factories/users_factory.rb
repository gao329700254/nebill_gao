FactoryBot.define do
  factory :user do
    provider { 'google_oauth2' }
    uid      { SecureRandom.hex }
    name     { Faker::Name.name }
    email    { Faker::Internet.safe_email }
    sequence(:password) { |i| "password#{i}" }
    sequence(:password_confirmation) { |i| "password#{i}" }
    persistence_token { Faker::Lorem.characters(10) }
    role     { :general }

    factory :admin_user do
      role { :admin }
    end

    factory :un_register_user do
      provider { nil }
      uid      { nil }
      name     { nil }
    end

    trait :with_project do
      transient { project { create(:project) } }
      after :create do |user, evaluator|
        user.members.build(project: evaluator.project).save!
      end
    end
  end
end
