require 'rails_helper'

RSpec.describe PartnerMember do
  let(:partner_member) { build(:partner_member) }
  subject { partner_member }

  it { is_expected.to have_one(:partner).through(:employee).source(:actable) }
  it { is_expected.to validate_presence_of(:unit_price) }
  it { is_expected.to validate_numericality_of(:working_rate).allow_nil }
  it { is_expected.to validate_numericality_of(:max_limit_time).is_greater_than(partner_member.min_limit_time) }
  it { is_expected.to validate_numericality_of(:max_limit_time).allow_nil }
end
