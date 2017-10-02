require 'rails_helper'

RSpec.describe PartnerMember do
  let(:partner_member) { build(:partner_member) }
  subject { partner_member }

  it { is_expected.to have_one(:partner).through(:employee).source(:actable) }
  it { is_expected.to validate_numericality_of(:working_rate).allow_nil }
  it { is_expected.to validate_numericality_of(:max_limit_time).only_integer.allow_nil }
  it { is_expected.to validate_numericality_of(:min_limit_time).only_integer.allow_nil }

  context 'with_partner' do
    it { is_expected.to accept_nested_attributes_for(:partner) }
  end
end
