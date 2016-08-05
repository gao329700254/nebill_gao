include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :project_file do
    project
    file    { fixture_file_upload Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpg' }
  end
end
