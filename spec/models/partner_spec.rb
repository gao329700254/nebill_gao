require 'rails_helper'

RSpec.describe Partner do
  let(:partner) { build(:partner) }
  subject { partner }

  it { is_expected.to have_many(:members).through(:employee).class_name('PartnerMember') }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:company_name) }

  it { expect(Partner).to act_as(:employee) }

  it { is_expected.to validate_presence_of(:cd) }
  it { is_expected.to validate_uniqueness_of(:cd).case_insensitive }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:company_name) }
end
