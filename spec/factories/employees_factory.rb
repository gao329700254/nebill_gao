FactoryBot.define do
  factory :employee do
    association :member
    association :project

    name {'Tester'}
    email {'example@email.co.jp'}

    after(:create) do |employee|
      create_list(:project, 3, employees: [employee] )
    end

  end
end