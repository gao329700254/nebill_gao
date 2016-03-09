FactoryGirl.define do
  factory :user do
    provider 'google_oauth2'
    uid      { SecureRandom.hex }
    name     { Faker::Name.name }
    email    { Faker::Internet.safe_email }
    persistence_token 'MyToken'
    is_admin false

    factory :admin_user do
      is_admin true
    end

    factory :un_register_user do
      provider nil
      uid      nil
      name     nil
    end
  end
end
