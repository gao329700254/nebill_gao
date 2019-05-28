FactoryGirl.define do
  factory :client_file do
    client
    file    { fixture_file_upload Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg' }
    original_filename { "#{Faker::Lorem.word}.jpg" }
    legal_check true

    trait :nda do
      file_type 10
    end

    trait :basic_contract do
      file_type 20
    end
  end

end
