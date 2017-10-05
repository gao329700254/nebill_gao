FactoryGirl.define do
  factory :member do
    bill
  end

  factory :user_member, parent: :member, class: UserMember do
    after(:build) { |user_member| user_member.employee = create(:user).employee }
  end

  factory :partner_member, parent: :member, class: PartnerMember do
    after(:build) { |partner_member| partner_member.employee = create(:partner).employee }
    unit_price 1
    working_rate 0.6
    min_limit_time 1
    max_limit_time 2
  end
end
