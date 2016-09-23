FactoryGirl.define do
  factory :member do
    association :employee, factory: :user
    project
  end

  factory :user_member, parent: :member, class: UserMember do
  end

  factory :partner_member, parent: :member, class: PartnerMember do
    unit_price 1
    min_limit_time 1
    max_limit_time 2
  end
end
