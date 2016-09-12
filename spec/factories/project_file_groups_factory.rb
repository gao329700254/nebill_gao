FactoryGirl.define do
  factory :project_file_group do
    project
    name { Faker::App.name }
  end
end
