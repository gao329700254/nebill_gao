require 'rails_helper'

RSpec.describe Partner do
  let(:partner) { build(:partner) }
  subject { partner }

  it { is_expected.to have_many(:members).through(:employee).class_name('PartnerMember') }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }

  it { expect(Partner).to act_as(:employee) }
end
