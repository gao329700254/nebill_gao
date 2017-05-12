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

  describe '#join!' do
    let(:project) { create(:project) }
    before do
      partner.save!
      partner.join!(project, 1, 0.6, 1, 2)
    end

    its(:projects) { is_expected.to include project }
  end

end
