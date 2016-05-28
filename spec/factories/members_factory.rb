FactoryGirl.define do
  factory :member do
    association :employee, factory: :user
    project
  end
end
