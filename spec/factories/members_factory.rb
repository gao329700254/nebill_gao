FactoryBot.define do
  factory :member do
    project
    employee
  end

  factory :user_member, parent: :member, class: UserMember do
    after(:build) { |user_member| user_member.employee = create(:user).employee }
  end

  factory :partner_member, parent: :member, class: PartnerMember do
    transient { partner { create(:partner) } }
    after(:build) { |partner_member, evaluator| partner_member.employee = evaluator.partner.employee }
    unit_price { 1 }
    working_rate { 0.6 }
    min_limit_time { 1 }
    max_limit_time { 2 }
  end
end
