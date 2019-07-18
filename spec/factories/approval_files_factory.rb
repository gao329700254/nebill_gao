FactoryBot.define do
  factory :approval_file do
    approval
    file    { fixture_file_upload Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg' }
    original_filename { "#{Faker::Lorem.word}.jpg" }
  end
end
