include ActionDispatch::TestProcess

FactoryBot.define do
  factory :project_file do
    project
    association :group, factory: :project_file_group
    file    { fixture_file_upload Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg' }
    original_filename { "#{Faker::Lorem.word}.jpg" }
  end
end
